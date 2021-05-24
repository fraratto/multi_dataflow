# Multi-dataflow
Repository for the developement of accelerators based on tagged-dataflow.


## Repo organization
```
.
└─ src
│    │─── actors:   basic actor of different type (accumulator);  
│    │─── actors:   basic actor of different type (accumulator);  
│    │─── fifo:     different fifos;
│    │─── hevc:	   actors for hevc filter;
│    │─── tb:       tbs for some components;
│    └─── wrappers: wrappers for synthesis;
│
└─── tcl : tcl files to create basic projects
```

## Create projects
- Run Vivado
- Go to multi_dataflow
- source ./tcl/<prj_name>.tcl
