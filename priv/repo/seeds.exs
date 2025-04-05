alias Raffley.Repo
alias Raffley.Accounts.User
import Ecto.Query

# Fetch admin email and password from environment variables
admin_email = System.get_env("ADMIN_EMAIL")
admin_password = System.get_env("ADMIN_PASSWORD")

if admin_email && admin_password do
  unless Repo.exists?(from u in User, where: u.email == ^admin_email) do
    # Define the admin user attributes
    admin_user = %{
      email: admin_email,
      password: admin_password,
      password_hash: Bcrypt.hash_pwd_salt(admin_password),
      admin: true,
      confirmed_at: DateTime.utc_now()
    }

    # Insert the admin user into the database
    case %User{}
         |> User.registration_changeset(admin_user)
         |> Repo.insert() do
      {:ok, _user} ->
        IO.puts("Admin user created successfully.")

      {:error, changeset} ->
        IO.inspect(changeset.errors, label: "Failed to create admin user")
    end
  else
    IO.puts("Admin user already exists.")
  end
else
  IO.puts("ADMIN_EMAIL and ADMIN_PASSWORD must be set in the environment.")
end
