defmodule PointerPokerWeb.IndexLive do
  use PointerPokerWeb, :live_view
  use Phoenix.Component
  alias PointerPokerWeb.Presence
  alias PointerPoker.Pointer

  embed_templates("index/*")

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       users: [],
       name: nil,
       slug: nil,
       point: "0",
       reveal: false,
       editing_name: false,
       values: ["1", "2", "3", "5", "8", "13", "21", "?"]
     )}
  end

  def handle_params(%{"room" => room}, _uri, socket) do
    # slug = get_slug(socket)

    if connected?(socket) do
      # name = get_name(socket)
      # Presence.track(self(), room, slug, %{slug: slug, name: name, point: "0", reveal: false})

      # Phoenix.PubSub.subscribe(PointerPoker.PubSub, room)
    end

    socket =
      assign(socket,
        room_name: room,
        users: Presence.list(room) |> get_users
      )

    # |> assign_new(:slug, fn -> slug end)

    IO.inspect(socket, label: "initial socket")

    {:noreply, socket}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="text-4xl font-bold mx-auto my-6">Pointing Poker</h1>
      <.create_room :if={@live_action != :show} />
      <section :if={@live_action == :show} class="flex gap-4" phx-hook="restore" id="pointing-poker">
        <.pointer
          users={@users}
          editing_name={@editing_name}
          slug={@slug}
          values={@values}
          reveal={@reveal}
        >
        </.pointer>
        <.stats
          :if={@reveal}
          has_consensus={Pointer.has_consensus(@users)}
          mean={Pointer.calc_mean(@users)}
          max={Pointer.calc_max(@users)}
          min={Pointer.calc_min(@users)}
          }
        >
        </.stats>
      </section>
    </div>
    """
  end

  def handle_event("create-room", %{"room" => room, "username" => username}, socket) do
    socket =
      assign(socket,
        name: username,
        room_name: room
      )

    socket =
      push_event(socket, "saveName", %{
        name: username || socket.assigns.name,
        id: get_slug(socket)
      })

    {:noreply, socket}
  end

  def handle_event("rename", %{"name" => name}, socket) do
    socket =
      assign(socket,
        name: name,
        editing_name: false
      )

    socket =
      push_event(socket, "saveName", %{
        name: name,
        id: get_slug(socket)
      })

    %{metas: [meta | _]} = Presence.get_by_key(socket.assigns.room_name, socket.assigns.slug)
    Presence.update(self(), socket.assigns.room_name, socket.assigns.slug, %{meta | name: name})

    {:noreply, socket}
  end

  def handle_event("saved-name", _, socket) do
    {:noreply, push_patch(socket, to: "/#{socket.assigns.room_name}")}
  end

  def handle_event("edit-name", _, socket) do
    socket = assign(socket, editing_name: true)
    {:noreply, socket}
  end

  def handle_event("restore", %{"name" => name, "id" => id}, socket) do
    IO.puts("restore")

    socket =
      socket
      |> assign(slug: id || get_slug(socket))
      |> assign(name: name || get_name(socket))

    %{slug: slug, name: name, room_name: room} = socket.assigns

    Presence.track(self(), room, slug, %{slug: slug, name: name, point: "0", reveal: false})
    Phoenix.PubSub.subscribe(PointerPoker.PubSub, room)
    {:noreply, socket}
  end

  def handle_event("point", %{"options" => point}, socket) do
    socket = assign(socket, point: point)
    IO.inspect(point, label: "point")
    %{metas: [meta | _]} = Presence.get_by_key(socket.assigns.room_name, socket.assigns.slug)
    Presence.update(self(), socket.assigns.room_name, socket.assigns.slug, %{meta | point: point})
    {:noreply, socket}
  end

  def handle_event("reveal", _, socket) do
    socket = assign(socket, reveal: true)
    %{metas: [meta | _]} = Presence.get_by_key(socket.assigns.room_name, socket.assigns.slug)
    Presence.update(self(), socket.assigns.room_name, socket.assigns.slug, %{meta | reveal: true})

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: payload} = event, socket) do
    presences = Presence.list(socket.assigns.room_name)
    dbg(presences)

    socket =
      socket
      |> assign(users: get_users(presences))
      |> assign(reveal: reveal_all(presences))

    {:noreply, socket}
  end

  defp reveal_all(presences) do
    Enum.all?(presences, fn {_, %{metas: [meta | _]}} -> meta.point != "0" end) ||
      Enum.find_value(presences, fn {_, %{metas: [meta | _]}} -> meta.reveal == true end) != nil
  end

  def pointer(assigns)

  def create_room(assigns) do
    ~H"""
    <div class="flex gap-10">
      <form
        id="create-room-form"
        class="form-control w-full max-w-xs"
        phx-hook="save"
        phx-submit="create-room"
      >
        <label class="label">
          <span class="label-text">Room name</span>
        </label>
        <input
          type="text"
          name="room"
          placeholder="Rooom name"
          class="input input-bordered w-full max-w-xs"
        />
        <label class="label">
          <span class="label-text">User Name</span>
        </label>
        <input
          type="text"
          name="username"
          placeholder="User Name"
          class="input input-bordered w-full max-w-xs"
        />
        <button class="btn mt-2">Create</button>
      </form>
      <div>
        <p class="text-lg mb-4">Please follow the instructions below to get started:</p>

        <ul class="list-disc ml-6">
          <!-- Step 1: Room Name -->
          <li class="text-lg mb-2">Choose a Room Name.</li>
          <!-- Step 2: User Name -->
          <li class="text-lg mb-2">Enter Your User Name.</li>
          <!-- Step 3: Invite Others -->
          <li class="text-lg mb-2">
            Invite Others: Share the generated link with other participants.
          </li>
          <!-- Step 4: Start Pointing! -->
          <li class="text-lg">Start Pointing: Begin the pointing poker process.</li>
        </ul>
      </div>
    </div>
    """
  end

  def stats(assigns) do
    ~H"""
    <div class="card w-96 bg-base-100 shadow-xl">
      <div class="card-body">
        <div class="overflow-x-auto">
          <table class="table">
            <!-- head -->
            <thead>
              <tr>
                <th></th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <!-- row 1 -->
              <tr>
                <td>Average</td>
                <td><%= @mean %></td>
              </tr>
              <!-- row 2 -->
              <tr>
                <td>More Optimistic</td>
                <td><%= @min %></td>
              </tr>
              <!-- row 3 -->
              <tr>
                <td>More Caution</td>
                <td><%= @max %></td>
              </tr>
            </tbody>
          </table>
          <div :if={@has_consensus} class="alert alert-success mt-3">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              class="stroke-current shrink-0 h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <span>Consensus!</span>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp get_users(presences) do
    Enum.map(presences, fn {_, %{metas: [meta | _]}} -> meta end)
  end

  defp get_slug(socket) do
    socket.assigns.slug || MnemonicSlugs.generate_slug()
  end

  defp get_name(socket) do
    socket.assigns.name || get_slug(socket)
  end
end
