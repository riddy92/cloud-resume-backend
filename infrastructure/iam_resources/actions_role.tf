
module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  version = "5.30.0"

  tags = {
    Environment = "dev"
  }
}

module "iam_github_oidc_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  version = "5.30.0"

  # This should be updated to suit your organization, repository, references/branches, etc.
  subjects = ["repo:riddy92/cloud-resume-backend:*"]

  policies = {
    additional = aws_iam_policy.additional.arn
    PowerUserAccess = "arn:aws:iam::aws:policy/PowerUserAccess"

  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_policy" "additional" {
  name        = "github_oidc_additional"
  description = "Additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "iam:CreateRole",
                "iam:CreatePolicy",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:ListPolicies",
                "iam:TagPolicy",
                "iam:CreateOpenIDConnectProvider",
                "iam:TagRole",
                "iam:TagOpenIDConnectProvider",
                "iam:GetOpenIDConnectProvider",
                "iam:DeleteOpenIDConnectProvider",
                "iam:ListPolicyVersions",
                "iam:GetPolicyVersion",
				        "iam:CreatePolicyVersion",
				        "iam:DeletePolicyVersion",
				        "iam:SetDefaultPolicyVersion",
                "iam:GetPolicy",
				        "iam:GetRole",
                "iam:ListRolePolicies",
                "iam:List*",
                "iam:Get*"

            ],
            "Resource": [
                "*"
            ]
        },
    ]
  })

  tags = {
    Environment = "dev"
  }
}