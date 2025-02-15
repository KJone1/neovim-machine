FROM anatolelucet/neovim:stable-ubuntu
RUN apt-get update && apt-get upgrade -y || true
RUN dpkg --configure -a && apt-get install --no-install-recommends -f -y
RUN apt-get install --no-install-recommends -y \
	git \
	ssh \
	curl \
	wget \
	nodejs \
	npm \
	python3 \
	golang-go \
	python3-pip \
	ripgrep \
	fzf \
 	jq \
  	yq \
   	tmux

COPY ./config/nvim /root/.config/nvim
COPY ./share/nvim /root/.local/share/nvim

RUN apt-get update && apt-get install -y \
	libgpgme-dev \
	libbtrfs-dev

ENV PATH="$PATH:/root/.local/share/nvim/mason/bin"

RUN chmod +x /root/.local/share/nvim/mason/bin

RUN go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.64.5
RUN npm install -g typescript
RUN npm install -g typescript-language-server typescript
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \
	grep -Po '"tag_name": *"v\K[^"]*') && \
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
	tar xf lazygit.tar.gz lazygit && \
	install lazygit -D -t /usr/local/bin/ && \
	rm -rf lazygit.tar.gz lazygit
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.local/bin
CMD ["tail", "-f", "/dev/null"]
