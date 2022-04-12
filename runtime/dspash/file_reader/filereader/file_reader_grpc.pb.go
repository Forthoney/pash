// Code generated by protoc-gen-go-grpc. DO NOT EDIT.
// versions:
// - protoc-gen-go-grpc v1.2.0
// - protoc             v3.15.8
// source: filereader/file_reader.proto

package filereader

import (
	context "context"
	grpc "google.golang.org/grpc"
	codes "google.golang.org/grpc/codes"
	status "google.golang.org/grpc/status"
)

// This is a compile-time assertion to ensure that this generated file
// is compatible with the grpc package it is being compiled against.
// Requires gRPC-Go v1.32.0 or later.
const _ = grpc.SupportPackageIsVersion7

// FileReaderClient is the client API for FileReader service.
//
// For semantics around ctx use and closing/ending streaming RPCs, please refer to https://pkg.go.dev/google.golang.org/grpc/?tab=doc#ClientConn.NewStream.
type FileReaderClient interface {
	ReadFile(ctx context.Context, in *FileRequest, opts ...grpc.CallOption) (FileReader_ReadFileClient, error)
}

type fileReaderClient struct {
	cc grpc.ClientConnInterface
}

func NewFileReaderClient(cc grpc.ClientConnInterface) FileReaderClient {
	return &fileReaderClient{cc}
}

func (c *fileReaderClient) ReadFile(ctx context.Context, in *FileRequest, opts ...grpc.CallOption) (FileReader_ReadFileClient, error) {
	stream, err := c.cc.NewStream(ctx, &FileReader_ServiceDesc.Streams[0], "/FileReader/ReadFile", opts...)
	if err != nil {
		return nil, err
	}
	x := &fileReaderReadFileClient{stream}
	if err := x.ClientStream.SendMsg(in); err != nil {
		return nil, err
	}
	if err := x.ClientStream.CloseSend(); err != nil {
		return nil, err
	}
	return x, nil
}

type FileReader_ReadFileClient interface {
	Recv() (*ReadReply, error)
	grpc.ClientStream
}

type fileReaderReadFileClient struct {
	grpc.ClientStream
}

func (x *fileReaderReadFileClient) Recv() (*ReadReply, error) {
	m := new(ReadReply)
	if err := x.ClientStream.RecvMsg(m); err != nil {
		return nil, err
	}
	return m, nil
}

// FileReaderServer is the server API for FileReader service.
// All implementations must embed UnimplementedFileReaderServer
// for forward compatibility
type FileReaderServer interface {
	ReadFile(*FileRequest, FileReader_ReadFileServer) error
	mustEmbedUnimplementedFileReaderServer()
}

// UnimplementedFileReaderServer must be embedded to have forward compatible implementations.
type UnimplementedFileReaderServer struct {
}

func (UnimplementedFileReaderServer) ReadFile(*FileRequest, FileReader_ReadFileServer) error {
	return status.Errorf(codes.Unimplemented, "method ReadFile not implemented")
}
func (UnimplementedFileReaderServer) mustEmbedUnimplementedFileReaderServer() {}

// UnsafeFileReaderServer may be embedded to opt out of forward compatibility for this service.
// Use of this interface is not recommended, as added methods to FileReaderServer will
// result in compilation errors.
type UnsafeFileReaderServer interface {
	mustEmbedUnimplementedFileReaderServer()
}

func RegisterFileReaderServer(s grpc.ServiceRegistrar, srv FileReaderServer) {
	s.RegisterService(&FileReader_ServiceDesc, srv)
}

func _FileReader_ReadFile_Handler(srv interface{}, stream grpc.ServerStream) error {
	m := new(FileRequest)
	if err := stream.RecvMsg(m); err != nil {
		return err
	}
	return srv.(FileReaderServer).ReadFile(m, &fileReaderReadFileServer{stream})
}

type FileReader_ReadFileServer interface {
	Send(*ReadReply) error
	grpc.ServerStream
}

type fileReaderReadFileServer struct {
	grpc.ServerStream
}

func (x *fileReaderReadFileServer) Send(m *ReadReply) error {
	return x.ServerStream.SendMsg(m)
}

// FileReader_ServiceDesc is the grpc.ServiceDesc for FileReader service.
// It's only intended for direct use with grpc.RegisterService,
// and not to be introspected or modified (even as a copy)
var FileReader_ServiceDesc = grpc.ServiceDesc{
	ServiceName: "FileReader",
	HandlerType: (*FileReaderServer)(nil),
	Methods:     []grpc.MethodDesc{},
	Streams: []grpc.StreamDesc{
		{
			StreamName:    "ReadFile",
			Handler:       _FileReader_ReadFile_Handler,
			ServerStreams: true,
		},
	},
	Metadata: "filereader/file_reader.proto",
}
