# webhook

https://github.com/adnanh/webhook

https://github.com/adnanh/webhook/issues/453

You need something like this as hooks.json:

[
  {
    "id": "webhook",
    "execute-command": "/var/lib/laminar/wrapper.pl",
    "command-working-directory": "/var/lib/laminar",
    "pass-environment-to-command":
    [
      {
        "source": "payload",
        "envname": "git_username",
        "name": "pusher.username"
      },
      {
        "source": "payload",
        "envname": "git_login",
        "name": "pusher.login"
      },
      {
        "source": "payload",
        "envname": "git_email",
        "name": "pusher.email"
      },
      {
        "source": "payload",
        "envname": "git_repo",
        "name": "repository.name"
      },
      {
        "source": "payload",
        "envname": "git_before",
        "name": "before"
      },
      {
        "source": "payload",
        "envname": "git_after",
        "name": "after"
      },
      {
        "source": "payload",
        "envname": "git_repository_full_name",
        "name": "repository.full_name"
      }
    ],
    "trigger-rule":
    {
      "and":
      [
        {
          "match":
          {
            "type": "value",
            "value": "my_token",
            "parameter":
            {
              "source": "url",
              "name": "token"
            }
          }
        },
        {
          "match":
          {
            "type": "value",
            "value": "refs/heads/master",
            "parameter":
            {
              "source": "payload",
              "name": "ref"
            }
          }
        }
      ]
    }
  }
]
and setup hook in gitea itself
http://127.0.0.1:9080/hooks/webhook?token=my_token
It is described in docs.