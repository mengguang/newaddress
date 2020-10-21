defmodule NewChain.Address do
  @moduledoc """
  Documentation for `NewChain.Address`.
  """

  def hex_address_to_new_address(hex_address, chain_id) when is_binary(hex_address) and is_integer(chain_id) do
    if(String.length(hex_address) != 42 || String.starts_with?(hex_address, "0x") == false) do
      hex_address
    else
      {_prefix, address} = String.split_at(hex_address, 2)
      case Base.decode16(address, case: :mixed) do
        {:ok, binary_address} ->
          hex_chain_id = Integer.to_string(chain_id, 16)
          binary_chain_id = case rem(String.length(hex_chain_id), 2) do
            0 -> Base.decode16!(hex_chain_id, case: :mixed)
            1 -> Base.decode16!("0" <> hex_chain_id, case: :mixed)
          end
          "NEW" <> B58.encode58_check!(binary_chain_id <> binary_address, 0)
        :error ->
          hex_address
      end
    end
  end

  def new_address_to_hex_address(new_address) when is_binary(new_address) do
    if(String.length(new_address) < 38 || String.starts_with?(new_address, "NEW") == false) do
      new_address
    else
      {_prefix, data} = String.split_at(new_address, 3)
      case B58.decode58_check(data) do
        {:ok, {chain_id_and_binary_address, _version}} ->
          <<_chainId :: bytes - size(2), binary_address :: bits>> = chain_id_and_binary_address
          "0x" <> Base.encode16(binary_address, case: :lower)
        {:error, _message} ->
          new_address
      end
    end

  end

  def trimmed_new_address_easy(address) do
    chain_id = Application.fetch_env!(:newaddress, :chain_id)
    new_address =
      address
      |> to_string
      |> hex_address_to_new_address(chain_id)
    "#{String.slice(new_address, 0..6)}-#{String.slice(new_address, -5..-1)}"
  end

  def full_new_address_easy(address) do
    chainId = Application.fetch_env!(:newaddress, :chain_id)
    address
    |> to_string
    |> hex_address_to_new_address(chainId)
  end

end
