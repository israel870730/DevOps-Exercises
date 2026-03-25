#IRSA (IAM Roles for Service Accounts)
# IAM Policy
resource "aws_iam_policy" "external_dns" {
  name        = "demo-externaldns-external-dns-irsa"
  description = "External DNS IAM policy."
  path        = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "route53:ChangeResourceRecordSets"
        Effect = "Allow"
        #Resource = "arn:aws:route53:::hostedzone/Z07668723K5UR5QHI2M4L" # To change
        Resource = [
          "arn:aws:route53:::hostedzone/Z07668723K5UR5QHI2M4L", # To change
          "arn:aws:route53:::hostedzone/Z06279791L1DKQV4M8L0Y"  # To change
        ]
      },
      {
        Action = [
          "route53:ListResourceRecordSets",
          "route53:ListHostedZones"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = {
    App_Name    = "Kubernetes_externaldns"
    Country     = "UY"
    Region      = "AMERICA"
    Environment = "poc"
    Terraform   = "true"
  }
}

# Crear SA desde la consola
# eksctl create iamserviceaccount -name externaldns-sa --namespace kube-system --cluster demo-externaldns \ 
# --attach-policy-arn arn:aws:iam::Account-ID:policy/demo-externaldns-external-dns-irsa --approve --region us-west-1

# IAM Role
resource "aws_iam_role" "irsa" {
  name        = "demo-externaldns-external-dns-sa-irsa"
  description = "AWS IAM Role for the Kubernetes service account external-dns-sa."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::Account-ID:oidc-provider/oidc.eks.us-west-1.amazonaws.com/id/EE43114F9087525B5A4AA85B0F6C6EE4" # To update
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            "oidc.eks.us-west-1.amazonaws.com/id/EE43114F9087525B5A4AA85B0F6C6EE4:aud" = "sts.amazonaws.com"                                # To update
            "oidc.eks.us-west-1.amazonaws.com/id/EE43114F9087525B5A4AA85B0F6C6EE4:sub" = "system:serviceaccount:kube-system:externaldns-sa" # To update
          }
        }
      }
    ]
  })

  tags = {
    App_Name    = "Kubernetes_externaldns"
    Country     = "UY"
    Region      = "AMERICA"
    Environment = "poc"
    Terraform   = "true"
  }
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "irsa" {
  policy_arn = aws_iam_policy.external_dns.arn
  role       = aws_iam_role.irsa.name
}

# Kubernetes Service Account
resource "kubernetes_service_account_v1" "irsa" {
  metadata {
    name      = "externaldns-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa.arn
    }
  }

  automount_service_account_token = true
}

