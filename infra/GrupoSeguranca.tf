resource "aws_security_group" "alb" { #rede publica
  name        = "alb_ECS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb" { 
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"] #Recebe de qualquer lugar
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "saida_alb" {
  type              = "egress"
  from_port         = 0 # Reponde a qlqr porta
  to_port           = 0
  protocol          = "-1" #qlqr protocolo
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "privado" {
  name        = "privado_ECS"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "entrada_ECS" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id = aws_security_group.alb.id # recebe requisicoes apenas da rede publica (do application load balancer)
  security_group_id = aws_security_group.privado.id
}

resource "aws_security_group_rule" "saida_ECS" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #0.0.0.0 - 255.255.255.255
  security_group_id = aws_security_group.privado.id
}
