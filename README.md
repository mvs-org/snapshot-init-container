## Usage

Adding it as an init container in Kubernetes manifests and fill the correct values to the environment variables:

```yaml
volumes:
  - name: snapshot
    emptyDir: {}

initContainers:
  - name: init-snapshot
    # Replace <VERSION> to one of the GitHub releases.
    image: viewfintest/snapshot-init-container:<VERSION>
    volumeMounts:
      # Mount an emptyDir volume on /snapshot helps continue downloading if the init container restarted.
      - name: snapshot
        mountPath: /snapshot
      # Do not forget to mount the chain database volume.
      - name: data
        mountPath: /data
    env:
      #
      # Required, the URL of the snapshot archive(an archive version of the DB of HyperSpace (or any other network))
      # Supported file types:
      #
      # - Gzip tar (URL must ends with .tar.gz)
      # - Zstandard tar (URL must ends with .tar.zst)
      # - 7-Zip (URL must ends with .7z)
      #
      - name: ARCHIVE_URL
        value: http://exmaple.com/snapshot.tar.gz

      #
      # Required, the path of chain directory
      # Example (assume with the node CLI option `--base=/data`):
      #
     #
      - name: CHAIN_DIR
        value: /data/chains/hyperspace

      #
      # Optional, if set, `chmod -R $CHMOD` will be used to reset the permissions of $CHAIN_DIR
      # Example: "777"
      #
      - name: CHMOD
        value: "777"

      #
      # Optional, if set, `chown -R $CHOWN` will be used to reset owners (and groups) of $CHAIN_DIR
      # Example: 1000:1000
      #
      - name: CHOWN
        value: 1000:1000
```

## Integration with Kubebot

See <https://github.com/mvs-org/kubebot/blob/master/deploy/manifests/statefulset.yaml>.

## Credits

- <https://github.com/midl-dev/polkadot-k8s/tree/master/docker/polkadot-archive-downloader>
