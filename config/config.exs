use Mix.Config

config :newaddress,
       chain_id: System.get_env("NEWCHAIN_CHAIN_ID", "1012")
                 |> String.to_integer
