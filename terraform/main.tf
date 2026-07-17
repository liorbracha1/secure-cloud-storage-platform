# 1. Create the main application S3 Bucket
resource "aws_s3_bucket" "secure_cloud_storage" {
  bucket        = var.bucket_name
  force_destroy = true # Allows deleting all objects easily at the end of the project

  tags = {
    Name        = "Secure-Cloud Storage"
    Environment = "Dev"
  }
}

# Block all public access to the Bucket (maximum security)
resource "aws_s3_bucket_public_access_block" "secure_cloud_storage_block" {
  bucket = aws_s3_bucket.secure_cloud_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# 2. Create IAM Role for Kubernetes Pods
resource "aws_iam_role" "k8s_pod_role" {
  name = "secure-cloud-k8s-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" # Later will be adapted for Kubernetes (IRSA)
        }
      }
    ]
  })
}


# IAM Policy allowing read/write access only to the application's Bucket
resource "aws_iam_policy" "s3_access_policy" {
  name        = "secure-cloud-s3-access-policy"
  description = "Allow Secure-Cloud pods to access S3 storage"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.secure_cloud_storage.arn,
          "${aws_s3_bucket.secure_cloud_storage.arn}/*"
        ]
      }
    ]
  })
}


# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.k8s_pod_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}



# 3. Create ECR Repository for Docker Images
resource "aws_ecr_repository" "secure_cloud_storage" {

  name = "secure-cloud-storage-platform"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "Secure Cloud Storage Platform"
    Environment = "Dev"
  }
}


# 4. GitHub Actions OIDC Provider

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com"
}


resource "aws_iam_openid_connect_provider" "github" {

  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.github.certificates[0].sha1_fingerprint
  ]
}


# 5. IAM Role for GitHub Actions

resource "aws_iam_role" "github_actions_role" {

  name = "secure-cloud-github-actions-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {

          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:liorbracha1/secure-cloud-storage-platform:*"
          }

        }
      }
    ]
  })
}


# 6. IAM Policy for ECR Push

resource "aws_iam_policy" "github_actions_ecr_policy" {

  name = "secure-cloud-github-actions-ecr-policy"

  description = "Allow GitHub Actions to push Docker images to ECR"


  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },


      {
        Effect = "Allow"

        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]

        Resource = aws_ecr_repository.secure_cloud_storage.arn
      }

    ]
  })
}


# 7. Attach ECR Policy to GitHub Actions Role

resource "aws_iam_role_policy_attachment" "github_actions_ecr_attach" {

  role = aws_iam_role.github_actions_role.name

  policy_arn = aws_iam_policy.github_actions_ecr_policy.arn
}
