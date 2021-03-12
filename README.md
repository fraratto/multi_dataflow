# Multi_dataflow
Tagged dataflow based accelerators.


## Repo organization
```
.
│─── src
│     │─── actors:   contains actors;  
│     │─── fifo:     contains fifos;
│     │─── tb:       contains tbs corresponding input and output files;
│     └─── wrappers: contains simple modules, e.g. fifo+actor;
│
└─── test:  contains .tcl files to create projects and run tests 
```

## Naming convention
  * **actors**: ```<type>_<n_ports>P_<n_fluxes>F  ```   (type can be SDF, CSDF or DDF);
  * **fifo**: ```FIFO_<type>(_PICK)  ```    (type can be Mono, MS or SR);

## How to run a test
  1. Open Vivado
  2. Move to ./multi_dataflow
  3. source ./test/test_name.tcl
