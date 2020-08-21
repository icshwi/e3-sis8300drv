# Deprecation notice

2020-08-21: This remote has been deprecated. Moved to https://gitlab.esss.lu.se/e3/llrf/e3-sis8300drv

e3-sis8300drv  
======
ESS Site-specific EPICS module : sis8300drv


## Build and install Vendor Library as e3 module

```
$ make init
$ make build
$ make install
```

## Vendor Applications

The e3 doesn't provide any card specific vendor applications within its structure, however, it allows users to install them. The following vendor applications can be installed in ```E3_MODULES_INSTALL_LOCATION_BIN``` with the suffix ```E3_MODULE_VERSION```

```
sis8300drv_acq
sis8300drv_i2c_rtm
sis8300drv_irq
sis8300drv_mmap
sis8300drv_perf
sis8300drv_rem
sis8300drv_flashfw
sis8300drv_i2c_temp
sis8300drv_mem
sis8300drv_out
sis8300drv_reg
sis8300drv_speed
```

One should execute ```make tools``` between ```make build``` and ```make install``` such as
```
$ make int
$ make build
$ make tools 
$ make install
```

However, e3 doesn't provide more than this. One should set the executable path manually. For example,

```
$ make tools_env
export PATH=/epics/base-3.15.5/require/3.0.0/siteLibs/sis8300drv_4.2.0_bin/linux-x86_64:${PATH}

$ export PATH=/epics/base-3.15.5/require/3.0.0/siteLibs/sis8300drv_4.2.0_bin/linux-x86_64:${PATH}

$  sis8300drv_flashfw_4.2.0
Device and firmware image argument required.

```


## Kernel module (sis8300drv.ko) can be installed via DKMS
Note that the following dependencies must be satisfied:  
EPICS Base installed to allow installation of E3 require.  
E3 Require installed to provide Make rules for kernel module installation.  
Kernel source must be available in /lib/modules directory.  
This can be obtained on centOS by installation of kernel-devel from system package manager.  

```sh
$ make init
$ make dkms_add
$ make dkms_build
$ make dkms_install
```

In order to remove them

```sh
$ make dkms_uninstall
$ make dkms_remove
```



## Kernel modules configuration

* Create and load udev rule in /etc/udev/rules.d/99-sis8300drv.rules
* Create and load the autoload configuration in /etc/modules-load.d/sis8300drv.conf
* Remove and load the kernel module with modprobe

```sh
$ make setup
```

In order to clean the configuration,

```sh
$ make setup_clean
```

## Notice
If one has already the running dkms.service in systemd, the next reboot with new kernl image will make the kernel module be ready. However, if one doesn't have one, please run bash dkms/dkms_setup.bash in order to enable dkms.service.

```
$ bash dkms/dkms_setup.bash
$ systemctl status dkms
● dkms.service - Builds and install new kernel modules through DKMS
   Loaded: loaded (/etc/systemd/system/dkms.service; enabled; vendor preset: ena
   Active: active (exited) since Sun 2018-07-29 01:13:59 CEST; 4s ago
     Docs: man:dkms(8)
  Process: 3271 ExecStart=/bin/sh -c dkms autoinstall --verbose --kernelver $(un
 Main PID: 3271 (code=exited, status=0/SUCCESS)
```


