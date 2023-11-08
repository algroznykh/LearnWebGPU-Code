<div align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/eliemichel/LearnWebGPU/main/images/webgpu-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/eliemichel/LearnWebGPU/main/images/webgpu-light.svg">
    <img alt="Learn WebGPU Logo" src="images/webgpu-dark.svg" width="200">
  </picture>

  <a href="https://github.com/eliemichel/LearnWebGPU">LearnWebGPU</a> &nbsp;|&nbsp; <a href="https://github.com/eliemichel/WebGPU-Cpp">WebGPU-C++</a> &nbsp;|&nbsp; <a href="https://github.com/eliemichel/glfw3webgpu">glfw3webgpu</a> &nbsp;|&nbsp; <a href="https://github.com/eliemichel/WebGPU-distribution">WebGPU-distribution</a>
  
  <a href="https://discord.gg/2Tar4Kt564"><img src="https://img.shields.io/static/v1?label=Discord&message=Join%20us!&color=blue&logo=discord&logoColor=white" alt="Discord | Join us!"/></a>
</div>


Building
--------

```
cmake . -B build -DWEBGPU_BACKEND=DAWN
cmake --build build
```

Then run `./build/App`
