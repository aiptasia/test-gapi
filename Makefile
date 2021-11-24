go_dir=gen/go
rb_dir=gen/rb

proto_files=\
	proto/garwinapis/search/v1/*.proto \
	proto/garwinapis/seo/v1/*.proto

lint:
	docker run --volume "$(shell pwd):/workspace" --workdir /workspace bufbuild/buf lint proto

compile: compile-go compile-rb

compile-go:
	docker run --volume "$(shell pwd):/workspace" --workdir /workspace golang:1.17-stretch make compile-go-in-docker

compile-rb:
	docker run --volume "$(shell pwd):/workspace" --workdir /workspace ruby:2.6.0 make compile-rb-in-docker


compile-go-in-docker:
	apt-get update && apt-get install -y unzip
	cd /tmp; curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-linux-x86_64.zip
	cd /tmp; unzip protoc-3.19.1-linux-x86_64.zip -d /usr

	cd $(go_dir); go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway
	cd $(go_dir); go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2
	cd $(go_dir); go install google.golang.org/grpc/cmd/protoc-gen-go-grpc
	cd $(go_dir); go install google.golang.org/protobuf/cmd/protoc-gen-go
	protoc -Iproto \
		--go_out=$(go_dir) \
		--go-grpc_out=$(go_dir) \
		$(proto_files)

compile-rb-in-docker:
	gem install grpc-tools
	which grpc_tools_ruby_protoc
	grpc_tools_ruby_protoc -Iproto \
		--ruby_out=$(rb_dir) \
		$(proto_files)
	cd $(rb_dir); cp -r garwinapis/* lib/garwinapis; rm -rf garwinapis
