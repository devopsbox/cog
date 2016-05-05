defmodule Cog.Commands.Sleep do
  use Cog.Command.GenCommand.Base, bundle: Cog.embedded_bundle,
                               execution: :once,
                               name: "sleep"

  @moduledoc """
  Sleep for a configurable number of seconds. Useful
  for testing timeout handling in executor logic.

  Passes COG_ENV through unchanged.

  Note, however, that invocations of this command are still subject to
  the current per-invocation timeout in the executor (1 minute).

  Currently useful mainly for debugging purposes.

  ## Example

      !echo "Get up and stretch" | sleep 10 | echo $body > me`

  """

  rule "when command is #{Cog.embedded_bundle}:sleep allow"

  alias Cog.Command.Request

  def handle_message(req, state) do
    case sleep_seconds(req) do
      {:ok, sec} ->
        :timer.sleep(sec * 1000)
        {:reply, req.reply_to, req.cog_env, state}
      :error ->
        {:error, req.reply_to, "Must specify a single integer sleep duration", state}
    end
  end

  defp sleep_seconds(%Request{args: [sec]}) when is_integer(sec),
    do: {:ok, sec}
  defp sleep_seconds(_),
    do: :error

end
