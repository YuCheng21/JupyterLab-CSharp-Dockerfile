## Build

``` bash
docker build --no-cache -t jupyterlab .
docker run -itd --restart=always -p 9876:8888 jupyterlab
```

## Related Command

1. Change the Jupyter password and restart Jupyter, then login with the new password.
  ``` bash
  $ jupyter notebook password
  # or
  $ jupyter lab password
  ```
2. Check out the list of Kernels that Jupyter has loaded, such as Python, C#, F#, etc.
  ``` bash
  $ jupyter kernelspec list
  ```

## Startup Script

- `jupyter.sh`
    ``` bash
    #!/bin/bash

    BEGIN=31006
    END=31012
    for ((i=$BEGIN; i<=$END; i++))
    do
            docker run -itd --restart=always -p $i:8888 --name=jupyterlab-$i  jupyterlab
    done
    ```