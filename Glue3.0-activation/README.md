## Build notes for Glue3.0-activation on WSL2 / ZSH / Podman

```bash
cd Glue3.0-activation
export CR_PAT=ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
source tag.sh
podman login ghcr.io -u apeyrat -p $CR_PAT
podman build . -t $DST
podman push $REPO/$IMG:$VERSION
```
