.PHONY=build install clean

SIGNAL_VERSION=$$(cat ./SIGNAL_VERSION | tr -d vV)
FEDORA_VERSION=$$(cat ./FEDORA_VERSION)
NVM_VERSION=$$(cat ./NVM_VERSION | tr -d vV)

all: build

build: clean
	@mkdir -p output
	@podman build --build-arg=FEDORA_VERSION=$(FEDORA_VERSION) --build-arg=SIGNAL_VERSION=$(SIGNAL_VERSION) --build-arg=NVM_VERSION=$(NVM_VERSION) -t signal-desktop-rpm:latest .
	@podman create --name signal-desktop-rpm signal-desktop-rpm:latest
	@podman cp signal-desktop-rpm:/output/signal-desktop-$(SIGNAL_VERSION).x86_64.rpm ./output

install:
	@-pkill --signal SIGHUP -x signal-desktop >/dev/null 2>/dev/null && sleep 2
	@-pkill --signal SIGKILL -x signal-desktop >/dev/null 2>/dev/null
	@sudo rpm -Uvh --force output/signal-desktop-$(SIGNAL_VERSION).x86_64.rpm
# Use flags that get wayland working properly
# which unfortunately includes --no-sandbox
	@sudo sed -i 's|Exec=/opt/Signal/signal-desktop.*|Exec=/opt/Signal/signal-desktop --no-sandbox --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto %U|g' /usr/share/applications/signal-desktop.desktop
# this fixes the otherwise missing icon
	@sudo sed -i 's|StartupWMClass=Signal|StartupWMClass=signal|g' /usr/share/applications/signal-desktop.desktop

clean:
	@podman unshare rm -rf ./output
	@-podman rm -f signal-desktop-rpm 2>/dev/null
