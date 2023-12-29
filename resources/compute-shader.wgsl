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
const B = array<i32, 12> (-172,-203,-249,333,68,356,219,293,228,308,-259,70);
const W = array<array<i32, 12>, 48>(
        array<i32, 12>(-570,-6,-50,69,82,37,125,64,78,191,-157,-20),         array<i32, 12>(-94,-501,-16,95,-12,-97,184,99,21,176,-63,-143),         array<i32, 12>(43,-73,-510,167,166,44,136,116,18,38,-137,-65),         array<i32, 12>(-11,-37,-94,-778,-172,-47,57,-153,157,79,-99,168),         array<i32, 12>(-50,-43,-94,226,-1208,307,-1,-62,-44,-30,-52,25),         array<i32, 12>(-59,-34,-67,15,-131,-1093,-24,64,-25,-82,58,11),         array<i32, 12>(2,-33,18,-47,-64,200,-934,188,130,48,1,45),         array<i32, 12>(-280,-291,-321,436,153,-114,-107,-1008,-46,102,-139,90),         array<i32, 12>(-100,-56,-33,13,18,-19,-99,223,-664,96,23,-50),         array<i32, 12>(-130,-125,-27,132,-91,-36,77,-52,-341,-1060,-496,56),         array<i32, 12>(-24,-21,-9,-253,135,-357,-165,132,-156,232,-763,-76),         array<i32, 12>(29,70,41,-188,-114,202,-29,41,160,73,110,-799),         array<i32, 12>(137,-77,-43,-20,-9,-15,55,-18,1,-18,-79,39),         array<i32, 12>(30,178,-86,-71,17,16,48,-17,-9,24,-59,50),         array<i32, 12>(-23,32,272,-55,-6,-10,34,-26,5,-10,-13,40),         array<i32, 12>(309,337,363,422,-52,-83,58,82,4,47,-37,-55),         array<i32, 12>(-26,-22,-38,54,-349,-204,18,28,-6,-28,-1,-39),         array<i32, 12>(-128,-127,-129,109,-54,250,-10,-20,-17,24,35,30),         array<i32, 12>(10,5,14,24,17,107,-79,20,-7,-4,22,5),         array<i32, 12>(1,-1,-8,-42,19,-92,45,-113,-43,52,-29,26),         array<i32, 12>(-126,-143,-133,-22,-4,36,-31,74,153,-157,-15,73),         array<i32, 12>(-60,-50,-39,142,21,-60,-55,148,3,-232,173,-118),         array<i32, 12>(-106,-95,-107,129,-13,8,-26,-120,-93,111,1,53),         array<i32, 12>(-12,-28,-21,-108,72,3,16,186,117,-134,149,228),         array<i32, 12>(-9,-173,-89,-235,209,-33,-207,43,-269,-252,75,-447),         array<i32, 12>(-194,11,-74,-230,262,22,-225,47,-225,-235,5,-323),         array<i32, 12>(-261,-205,13,-212,255,-51,-244,87,-271,-181,-3,-486),         array<i32, 12>(20,24,5,-245,-146,61,-126,-75,162,30,61,8),         array<i32, 12>(11,25,-21,-85,-532,-111,-31,-120,13,39,104,-36),         array<i32, 12>(-49,-45,-41,145,-61,-529,47,115,36,-126,17,-77),         array<i32, 12>(90,83,35,-99,-159,53,-136,2,63,215,351,-31),         array<i32, 12>(-97,-87,-97,110,-8,-11,-8,-39,-71,-61,84,31),         array<i32, 12>(-19,-1,14,184,-26,15,2,9,-13,-1,102,-90),         array<i32, 12>(108,118,73,-255,-134,7,-62,-124,77,128,-53,5),         array<i32, 12>(104,79,114,-282,-124,168,52,-300,-167,-190,-335,324),         array<i32, 12>(-59,-60,-58,-43,73,-135,28,-19,-64,-1,-99,456),         array<i32, 12>(-3,50,34,-30,-30,36,23,-15,27,10,-2,40),         array<i32, 12>(35,-11,26,3,-26,21,22,-49,30,4,-17,48),         array<i32, 12>(-4,-16,-39,95,35,-1,14,-12,-14,-14,-10,15),         array<i32, 12>(-76,-45,-10,93,228,34,56,92,-115,-148,3,-64),         array<i32, 12>(62,57,54,-28,71,78,28,-106,84,90,-27,-14),         array<i32, 12>(94,89,65,-134,-199,182,67,-135,4,88,-11,87),         array<i32, 12>(-59,-39,-7,271,64,-33,-84,39,-175,-116,-103,-153),         array<i32, 12>(55,46,16,-49,-163,43,17,-12,109,43,171,-48),         array<i32, 12>(140,118,115,-245,1,24,163,-200,-21,-81,-34,177),         array<i32, 12>(-6,-4,2,68,102,-69,71,61,88,-27,45,-56),         array<i32, 12>(75,74,60,63,102,-93,39,45,130,115,145,-61),         array<i32, 12>(-81,-72,-63,125,14,-68,-86,85,-69,-152,16,-171), );













// size of a simulation
const SW = 640;
const SH = 480 ;



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

    var tex = camlap(fragCoord) ;
    if (id.x >= screen_size.x || id.y >= screen_size.y) { return; }

    if (id.x < u32(SW) && id.y < u32(SH)) { 
        current_index = vec2i(i32(id.x), i32(id.y));
    

        // initial state
        if (uniforms.frame == 1u) {
            var init_s = array<f32, N>();
            for (var s=0u; s<N; s++) {
                let a = .01;
                let rand = fract(sin(f32((id.x + id.y* SW) * (s+1)) / f32(SW)) * 353348.5453123) + a;
                init_s[s] = floor(rand);
            }
        set_xy(u32(current_index.x), u32(current_index.y), init_s);
        return;
        }



		var ps = array<f32, 12>(
			lap(0u) + sin(tex.r),
			lap(1u) + sin(tex.g),
			lap(2u) + sin(tex.b),
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
    // xrgb = xrgb.xxxx ;
    var uv = vec2f(fragCoord) / vec2f(f32(SW), f32(SH));
    uv -= .5;
    uv *= 2.;
    // var tex = camlap(fragCoord) * .7;
    //xrgb = tex;

    // xrgb *= (1. - pow(length(uv), 2.) );

    xrgb *= xrgb * tex / 3.;

    textureStore(
        outputTexture,
        vec2i(id.xy),
        xrgb

    );
}
