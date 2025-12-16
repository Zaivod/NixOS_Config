{ config, pkgs, ... }:

{
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim
		wget
		git
		btop
		neofetch

		nvtopPackages.nvidia
		ollama
		onlyoffice-desktopeditors
	];

	# Onlyiffice unfree fonts
	fonts.packages = with pkgs; [
		corefonts
	];

	# Install firefox.
	programs.firefox.enable = true;

	# Docker
	virtualisation.docker.enable = true;
	hardware.nvidia-container-toolkit.enable = true; # use --device=nvidia.com/gpu=all instead of gpu=all

	# Ollama
	services.ollama = {
		enable = true;
		acceleration = "cuda";
		# Optional: preload models, see https://ollama.com/library
		# loadModels = [ "llama3.2:3b" "deepseek-r1:1.5b"];
	};

	# Github ssh
	programs.ssh = {
		# startAgent = true;	# Commented because of conflict with Cinnemon
		extraConfig = ''
			AddKeysToAgent yes
			IdentityFile /root/.ssh/github
		'';
	};

	# Nvidia driver
	hardware.graphics.enable = true;

	# Load nvidia driver for Xorg and Wayland
	services.xserver.videoDrivers = ["nvidia"];

	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = false;
		powerManagement.finegrained = false;
		open = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};
}
