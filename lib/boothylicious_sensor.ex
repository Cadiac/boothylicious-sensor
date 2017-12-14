defmodule BoothyliciousSensor do
  use Application

  require Logger

  alias ElixirALE.GPIO

  @output_pin Application.get_env(:hello_gpio, :output_pin, 26)
  @input_pin Application.get_env(:hello_gpio, :input_pin, 20)

  def start(_type, _args) do
    Logger.info "Starting pin #{@output_pin} as output"
    {:ok, output_pid} = GPIO.start_link(@output_pin, :output)

    Logger.info "Starting pin #{@input_pin} as input"
    {:ok, input_pid} = GPIO.start_link(@input_pin, :input)
    spawn fn -> listen_forever(input_pid, output_pid) end
    {:ok, self()}
  end

  defp listen_forever(input_pid, output_pid) do
    # Start listening for interrupts on rising and falling edges
    GPIO.set_int(input_pid, :both)
    listen_loop(output_pid)
  end

  defp listen_loop(output_pid) do
    # Infinite loop receiving interrupts from gpio
    receive do
      {:gpio_interrupt, p, :rising} ->
        Logger.debug "Received rising event on pin #{p}"
        GPIO.write(output_pid, 1)
      {:gpio_interrupt, p, :falling} ->
        Logger.debug "Received falling event on pin #{p}"
        GPIO.write(output_pid, 0)
    end
    listen_loop(output_pid)
  end
end
