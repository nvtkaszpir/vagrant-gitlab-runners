# gitlab-runner in vagrant

Example scripts to run different GitLab runners as virtual machines under
vagrant, as disposable, on-demand workers.

Shell scripts provided so that you really do not need anything else.
This can be easily converted into kickstart/preseed/cloudinit scripts.

## Notice

This is a quick proof of concept and is far from any production use.
There are already puppet/ansible modules/roles existing in the world.

## Providers

- virtualbox (not tested, but should work)
- libvirt
- LXC (Centos only), but it is deprecated, use vagrant-lxd
- LXD [vagrant-lxd](https://gitlab.com/catalyst-it/vagrant-lxd)

## Flavours

- Centos 7.4 + gitlab-runner as docker executor (basic)
- Centos 7.4 + gitlab-runner as shell executor, with docker, java and gcc++

- Ubuntu 16.04 + gitlab-runner as docker executor (basic)
- Ubuntu 16.04 + gitlab-runner as shell executor, with docker, java and gcc++

Centos installs new kernel mainline from elrepo.
Ubuntu installs kernel HWE LTS.

OpenJDK 8, headless, but no ant/maven.

## Preparing

- ensure you have vagrant installed, verion 2.2.5
- ensure you have vagrant plugin installed for given provider
  and it is properly configured, pro tip: read docs for given provider
  really carefully!
- ensure you have vagrant plugin vagrant-reload

```bash
vagrant plugin install vagrant-reload
```

- (optional) ensure you have proper plugin installed for given providers,
  for example vagrant-libvirt, vagrant-lxc, vagrant-lxd
- ensure you have configured system to be able to use given provider, refer to
  documentation details provided by given plugin (especially for LXD)

- go to your GitLab install, find project
- go to Settings (on the bottom left), CI/CD, Runners settings, click expand
- there is a section 'Specific Runners', with URL and token in red, copy it.

## Adjusting setup

- go into specific directory
- copy ``.secrets.dist`` to ``.secrets``

- edit ``.secrets`` and update runner name, URL, project token to register and tags

- execute command in shell, to load env vars:

```bash
. .secrets
```

- after command above executed, start vagrant:

```bash
vagrant up --provider=<providername>
```

- in the end of vagrant execution you should see something in red color (yeah...):

```text
vm-name: Registering runner... succeeded   runner=SOMETHING
vm-name: Runner registered successfully. Feel free to start it,
         but if it's running already the config should be automatically reloaded!
```

- go to the GitLab project, and check if in Runner settings you see registered
  runner.

- check your GitLab project and edit ``.gitlab-ci.yml`` to use proper tags in the
  project depending on the build/step and so on.

## Rebuilding machine

Pretty obvious

```bash
vagrant destroy -f
vagrant up --provider=<providername>
```

Remember to go to GitLab CI and remove dead workers.
