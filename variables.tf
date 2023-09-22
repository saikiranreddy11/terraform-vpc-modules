variable "vpc_cidr_block"{

}

variable "common_tags"{
   default ={}
}

variable "vpc_tags"{
   default ={}
}

variable "enable_dns_hostnames"{
    
}

variable "enable_dns_support"{
    
}

variable "public_cidr_block"{

}

variable "azs"{

}

variable "public_subnet_tags"{
   default ={}
}


variable "private_cidr_block"{

}


variable "db_cidr_block"{

}

variable "public_route"{
    default = {}    #this means , if the argument is not passed from the roboshop infra also, it gets executed
}

variable "routes"{

}