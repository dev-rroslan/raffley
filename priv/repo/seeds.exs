alias Raffley.Repo
alias Raffley.Accounts.User
import Ecto.Query

# Import Logger for production-friendly logging
require Logger

# Fetch admin email and password from environment variables
admin_email = System.get_env("ADMIN_EMAIL")
admin_password = System.get_env("ADMIN_PASSWORD")

if admin_email && admin_password do
  # Validate password length
  if String.length(admin_password) < 8 do
    Logger.error("Error: ADMIN_PASSWORD must be at least 8 characters long.")
    System.halt(1)
  end

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
        Logger.info("Admin user created successfully.")

      {:error, changeset} ->
        Logger.error("Error: Failed to create admin user. Check the changeset for details.")
        Logger.debug(inspect(changeset, label: "Invalid changeset"))
    end
  else
    Logger.info("Admin user already exists.")
  end
else
  Logger.error("Error: ADMIN_EMAIL and ADMIN_PASSWORD must be set in the environment.")
  Logger.info("Example: export ADMIN_EMAIL=admin@example.com ADMIN_PASSWORD=securepassword")
end
