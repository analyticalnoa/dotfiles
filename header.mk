SHELL = /bin/bash

ANENV_NIXPKGS=$(HOME)/nixpkgs

rm_cmd = rm -vf

fullpath = $$( readlink -f "$(1)" )

link_cmd = ln -fs
make_link = $(link_cmd) $(call fullpath,$<) "$@"
unmake_link = [ ! -L $(1) ] || $(rm_cmd) $(1)

get_shell = $$( awk -F: '$$1=="'"$$USER"'" {print $$7}' /etc/passwd )

nix_env_i_cmd = nix-env --install --file "$<" --attr "$(1)"
nix_env_e_cmd = nix-env --uninstall
install_nix_pkg = git -C "$<" checkout "$(1)" && $(call nix_env_i_cmd,$(2))
uninstall_nix_pkg = $(nix_env_e_cmd)

error_unsupported = $(error "Not yet supported: $@.")


# missing_command must be first rule in all makefiles.
.PHONY: missing_command
missing_command:
	$(error "Missing command. See README.md")

# all
# ------------------------------------------------------------------------------
all: install setup
unall: uninstall unsetup
# ------------------------------------------------------------------------------

# $(ANENV_NIXPKGS):
#	git clone $(ANENV_MASTERREMOTE)/nixpkgs
