defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :videos, Rumbl.Video, on_delete: :delete_all
    has_many :chattings, Rumbl.Chatting, on_delete: :delete_all
    has_many :chatting_room_users, Rumbl.ChattingRoomUser, on_delete: :delete_all
    many_to_many :chatting_rooms, Rumbl.ChattingRoom, join_through: "chatting_room_users"

    timestamps
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()

  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  def names_and_ids(query) do
    from u in query, select: {u.username, u.id}
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end

  end
end
