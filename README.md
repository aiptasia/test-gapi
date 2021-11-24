# Garwin APIs GRPC Library for Go

This repository contains the generated Go packages for the Garwin internal APIs. The source protocol buffer files are contained in the git submodule [_protos](https://gitlab.garagetools.ru/dev/grpc-protos).

In order to lint the protocol buffer files use the following command:

```
make lint
```

In order to regenerate the protocol buffer stubs use the following command:

```
make compile
```

Once the GarwinAPIs Go packages are regenerated, they should be tagged using [semantic versioning](https://semver.org) and pushed to the remote repository.
