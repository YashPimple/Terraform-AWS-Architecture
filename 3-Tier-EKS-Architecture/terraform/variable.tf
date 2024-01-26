variable "cluster_name" {
type = string
default = "my-eks-cluster"
}

variable "cluster_version" {
  type = number
  default = 1.25
}

variable "region" {
  type = string
  default = "ap-northeast-1"
}

variable "availability_zones" {
  type = list
  default = ["ap-northeast-1a", "ap-northeast-1b"]
}

variable "addons" {
  type = list(object({
    name = string
    version = string
  }))

  default = [ 
    {
    name = "kube-proxy"
    version = "v1.25.6-eksbuild.1"
  },
  {
    name = "vpc-cni"
    version = "v1.12.2-eksbuild.1"
  } ,
  {
    name = "coredns"
    version = "v1.9.3-eksbuild.2"
  },
  {
    name = "aws-ebs-csi-driver"
    version = "v1.23.0-eksbuild.1"
  }
  ]
}