Please see the instructions for how to use this artifact [online](https://www.cs.unc.edu/~jbakita/rtas23-ae/).

Key changes to Darknet:
1) Switch to `cudaMemcpyAsync()`, `cudaMallocAsync()` and `cudaFreeAsync()` to make sure no implicit synchronization occurs.
   Since all on-device operations use a stream, and the affected operations are only observable on-device, these do not need to be synchronous.
2) Remove superfluous `cudaDeviceSynchronize()` calls, such that `cudaDeviceSynchronize()` is only used in debug and benchmarking codepaths.
3) Fix `im2col_gpu_ext()` to launch its kernel into a stream (this was the only launch not using a stream).
4) Make sure that copies are from pinned host memory (so that a cudaMemcpyAsync is guaranteed to _actually_ be asynchronous) (Sec. 2, CUDA Runtime API Documentation).
5) Make all CUDA-related global variables per-thread.
6) Support setting the CUDA stream priority.
7) Add new test modes rtas23-case1, rtas23-case2, rtas23-case3, rtas23-case4, rtas23-split, and rtas23-pri to `detector`, which run multiple instances of darknet concurrently in different threads.
  - These are integrated with LITMUS-RT, extra.h, and libsmctrl to support periodic execution, timestamp logging, and space partitioning.
