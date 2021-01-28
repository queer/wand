defmodule Wand.Application do
  @moduledoc false

  use Application
  alias Wand.Cli
  require Logger

  @impl true
  def start(_type, _args) do
    {base_flags, argv} = OptionParser.parse_head! System.argv(), Cli.default_parse_opts()
    if Keyword.get(base_flags, :debug) do
      Logger.configure level: :debug
    else
      Logger.configure level: :error
    end
    Logger.debug "mahou: singyeong: dsn = #{Application.get_env :wand, :singyeong_dsn}"

    out = start_cli()
    if Keyword.get(base_flags, :debug) do
      Logger.configure level: :debug
    else
      Logger.configure level: :info
    end
    Cli.run base_flags, argv
    # give messages time to do the thing
    # TODO: lol
    :timer.sleep 50
    out
  end

  defp start_cli do
    ProgressBar.render_spinner [
      spinner_color: IO.ANSI.red(),
      text: [IO.ANSI.red(), "mahou: connecting..."],
      done: [IO.ANSI.green(), "mahou: connected!", IO.ANSI.reset()],
      frames: :bars,
    ], fn ->
      dsn =
        :wand
        |> Application.get_env(:singyeong_dsn)
        |> Singyeong.parse_dsn

      children = [
        {Singyeong.Client, dsn},
        Singyeong.Producer,
      ]

      opts = [strategy: :one_for_one, name: Wand.Supervisor]
      sup_res = Supervisor.start_link(children, opts)
      # give singyeong time to connect
      # TODO: lol
      :timer.sleep 500
      sup_res
    end
  end
end
