## Build notes for glue4.0-activation on WSL2 / ZSH / Docker / Podman

```bash
cd glue4.0-activation
export CR_PAT=ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
source tag.sh
podman login ghcr.io -u apeyrat -p $CR_PAT
podman build . -t $DST && podman push $REPO/$IMG:$VERSION
```
