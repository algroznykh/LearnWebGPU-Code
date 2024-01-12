struct Uniforms {
    kernel: mat3x3<f32>,
    filter_type: u32,
    frame: u32,
}

struct Storages {
    states: array<array<f32, 12>>,
}

// const SCREEN_WIDTH: i32 = 1024;
// const SCREEN_HEIGHT: i32 = 800;

// @group(0) @binding(0) var inputTexture: texture_2d<f32>;
@group(0) @binding(0) var outputTexture: texture_storage_2d<rgba8unorm, write>;
@group(0) @binding(1) var<uniform> uniforms: Uniforms;
@group(0) @binding(2) var<storage, read_write> storages: Storages;
@group(0) @binding(3) var camTexture: texture_2d<f32>;

const N = 12u;
const S = 5000.;
const B = array<i32, 12> (-292,-197,-303,325,-17,461,323,-191,129,308,-424,-485);
const W = array<array<i32, 12>, 48>(
        array<i32, 12>(-542,53,-8,49,-93,17,417,21,80,31,-119,-161),         array<i32, 12>(-51,-781,-80,231,254,136,92,61,160,111,-150,-186),         array<i32, 12>(5,68,-513,-63,73,11,420,-125,190,56,-105,-158),         array<i32, 12>(19,-90,62,-541,372,-212,318,-125,140,-199,-75,-20),         array<i32, 12>(31,-70,-20,-162,-1232,218,33,90,138,77,-30,34),         array<i32, 12>(22,-43,-7,277,-334,-1285,91,-24,-59,47,-131,-72),         array<i32, 12>(-158,73,-121,-110,78,-184,-1211,-39,-8,-57,-28,-148),         array<i32, 12>(-34,-41,51,-42,124,-59,-86,-1380,-138,-26,26,131),         array<i32, 12>(-51,-152,-99,-191,-176,78,250,146,-1422,30,179,-152),         array<i32, 12>(-110,-133,-89,39,-140,14,136,171,53,-814,-40,-284),         array<i32, 12>(141,186,145,-150,-60,42,-31,329,-22,-76,-1003,-179),         array<i32, 12>(138,191,224,-459,6,5,-95,-349,165,-3,-164,-1052),         array<i32, 12>(219,-79,2,46,38,38,19,-1,19,31,29,-4),         array<i32, 12>(-25,228,-74,-40,-18,-1,101,1,-21,2,23,-17),         array<i32, 12>(-60,-33,198,50,35,30,42,45,-16,1,15,19),         array<i32, 12>(-85,-2,-105,558,-100,108,28,-10,13,-161,-122,-138),         array<i32, 12>(20,4,22,20,334,-74,-21,27,4,97,44,67),         array<i32, 12>(21,68,24,109,-100,191,-110,-157,-79,-98,25,95),         array<i32, 12>(40,-7,32,-32,36,-322,61,118,36,-46,-33,-113),         array<i32, 12>(16,-18,24,-104,107,-96,53,14,-107,11,21,-41),         array<i32, 12>(-132,-150,-119,-216,61,118,-74,-85,87,42,82,183),         array<i32, 12>(8,15,-12,-56,-75,-12,-26,159,61,234,18,-139),         array<i32, 12>(154,129,140,35,-15,-7,86,183,57,45,293,-146),         array<i32, 12>(-54,-61,-49,-57,-72,-118,44,163,145,-7,15,-291),         array<i32, 12>(19,-224,-132,-400,253,-23,-51,-82,189,186,412,366),         array<i32, 12>(-125,-2,-117,-352,149,-31,87,-30,158,150,468,389),         array<i32, 12>(-122,-277,17,-341,194,14,-50,22,123,204,436,368),         array<i32, 12>(178,169,196,80,-27,110,137,-168,295,-67,-144,249),         array<i32, 12>(13,23,20,105,465,-71,65,-43,-161,24,-110,33),         array<i32, 12>(-5,-35,-18,172,-150,-598,3,37,35,28,7,3),         array<i32, 12>(-38,10,2,-36,-55,107,-364,-171,52,-142,-54,68),         array<i32, 12>(-90,-131,-94,-91,18,-128,74,-124,-251,17,106,69),         array<i32, 12>(-68,-103,-63,-39,-41,-6,153,88,-403,-34,121,-134),         array<i32, 12>(-87,-85,-68,-65,-164,129,53,47,-6,-233,124,-245),         array<i32, 12>(54,24,46,-99,-99,-10,18,28,62,1,-152,107),         array<i32, 12>(15,-53,5,-193,237,-45,149,156,-539,-80,242,-206),         array<i32, 12>(-50,2,-13,22,-45,-10,13,7,2,17,-23,-11),         array<i32, 12>(-12,-47,5,48,-51,15,-44,44,-20,-24,-25,-38),         array<i32, 12>(7,8,-55,-3,-20,-10,3,22,-30,-20,-19,-24),         array<i32, 12>(325,297,336,-14,-174,13,148,212,-56,-104,49,17),         array<i32, 12>(57,68,55,122,-7,63,-7,-67,105,-46,-89,22),         array<i32, 12>(183,195,178,179,-111,-31,54,76,57,-109,-29,-52),         array<i32, 12>(-144,-175,-151,-173,-127,-24,-160,4,6,165,154,112),         array<i32, 12>(168,225,165,293,-69,-24,-108,-33,124,-88,-55,52),         array<i32, 12>(-97,-129,-111,-89,18,-11,-42,92,93,81,33,79),         array<i32, 12>(-47,-76,-45,-56,-27,85,13,-144,13,122,-26,78),         array<i32, 12>(154,145,148,60,-61,96,94,85,-144,-143,89,-53),         array<i32, 12>(55,97,65,109,88,70,-5,-63,348,-14,-46,139), );










// size of a simulation
const SW = 320;
const SH = 240 ;



fn get_xy(x : u32, y: u32) -> array<f32,N> {
    let i = x + y*SW;
    return storages.states[i];
}

fn get_xyc(x : u32, y: u32, c: u32) -> f32 {
    let i = x + y*SW;
    return storages.states[i][c];
}

fn set_xy(x : u32, y: u32, cs: array<f32, N>) {
    let i = x + y*SW;
    storages.states[i] = cs;
}

var<private> current_index: vec2i;

fn R(dx: i32, dy: i32, c: u32) -> f32 {
    let x = u32(current_index.x + dx + SW) % SW;
    let y = u32(current_index.y + dy + SH) % SH;
    let val = get_xyc(x, y, c);
    return val;
}


fn lap(c: u32) -> f32 {
    return R(1,1,c)+R(1,-1,c)+R(-1,1,c)+R(-1,-1,c) 
        +2.0* ( R(0,1,c)+R(0,-1,c)+R(1,0,c)+R(-1,0,c) ) - 12.0*R(0, 0,c);
}

fn sobx(c: u32) -> f32 {
    return R(-1, 1, c) + R(-1, 0, c)*2.0 + R(-1,-1, c)
          -R( 1, 1, c) - R( 1, 0, c)*2.0 - R( 1,-1, c);
}

fn soby(c: u32) -> f32 {
    return R( 1, 1, c)+R( 0, 1, c)*2.0+R(-1, 1, c)
          -R( 1,-1, c)-R( 0,-1, c)*2.0-R(-1,-1, c);
}


fn update(xs: array<f32, N>, ps: array<f32, N>) -> array<f32, N> {
  // for some reason, accessing consts is very expensive, hence local vars
  // see https://bugs.chromium.org/p/tint/issues/detail?id=2032
  var ws = W;
  var bs = B;



  // construct hidden state
  var hs = array<f32, 48>();
  for (var i = 0u; i<N; i++) {
    hs[i] = xs[i];
    hs[i+N] = ps[i];
    hs[i+N*2u] = abs(xs[i]);
    hs[i+N*3u] = abs(ps[i]);
  }

  // do 1x1 conv
  var y = array<f32, N>();
  for (var c = 0u; c < N; c++) {
      var val = f32(bs[c]);

      for (var i = 0u; i < 48u; i++) {
          val += hs[i] * f32(ws[i][c]);
      }
      y[c] = xs[c] + val / S;
      y[c] = clamp(y[c], -1.5, 1.5);
  }

  if (abs(y[4]) < .01) {
      return xs;
  }

  return y;
}

fn camlap(coord: vec2i) -> vec4f {
    let lapmat = mat3x3<f32>(1, 2, 1, 2, -12, 2, 1, 2, 1);
    var res = vec4f(0.);
    for (var i = -1; i<3; i++) {
    for (var j = -1; j<3; j++) {
        res += textureLoad(camTexture, coord + vec2i(i, j), 0) * lapmat[i+1][j+1];

    }}
    // res /= 9.;
    return res;
}

@compute @workgroup_size(16, 16)
fn main_image(@builtin(global_invocation_id) id: vec3u) {

    let screen_size = vec2u(textureDimensions(outputTexture));
    let fragCoord = vec2i(i32(id.x), i32(id.y) );

    if (id.x >= screen_size.x || id.y >= screen_size.y) { return; }

    if (id.x < u32(SW) && id.y < u32(SH)) { 
        current_index = vec2i(i32(id.x), i32(id.y));
    

        // initial state
        if (uniforms.frame == 1u) {
            var init_s = array<f32, N>();
            for (var s=0u; s<N; s++) {
                let a = .02;
                let rand = fract(sin(f32((id.x + id.y* SW) * (s+1)) / f32(SW)) * 353348.5453123) + a;
                init_s[s] = floor(rand);
            }
        set_xy(u32(current_index.x), u32(current_index.y), init_s);
        return;
        }


        var tex = camlap(fragCoord) ;


		var ps = array<f32, 12>(
			lap(0u) + (tex.r - .5) *  1.  ,
			lap(1u) + (tex.g - .5 ) * 1.  ,
			lap(2u) + (tex.b - .5 ) * 1.  ,
			lap(3u),

			sobx(4u),
			sobx(5u),
			sobx(6u),
			sobx(7u),

			soby(8u),
			soby(9u),
			soby(10u),
			soby(11u)
		);
        
        // update state
        var xs = get_xy(u32(current_index.x), u32(current_index.y));    
        var state = update(xs, ps);

        //tex *= .25;
        //for (var i = 0u; i< 4; i++) {
        //    state[i] -= sin(length(tex) - 3.14 / 2.) / 4.;
        //}
        // state[4] += tex.r / 4. ;


        set_xy(u32(current_index.x), u32(current_index.y), state);
    }

    // rescale buffer 
    var idxs = u32(f32(id.x) / f32(screen_size.x) * f32(SW));
    var idys = u32(f32(id.y) / f32(screen_size.y) * f32(SH));

    // output to screen
    var states = get_xy(idxs, idys);
    var xrgb = vec4(states[0], states[1], states[2], states[3]) + .5;
    var uv = vec2f(fragCoord) / vec2f(f32(screen_size.x), f32(screen_size.y));
    uv -= .5;
    uv *= 2.;
    // var tex = camlap(fragCoord) * .7;
    //xrgb = tex;

    xrgb *= (1. - pow(length(uv), 2.) ) * length(xrgb) * 2.;
    textureStore(
        outputTexture,
        vec2i(id.xy),
        xrgb

    );
}
