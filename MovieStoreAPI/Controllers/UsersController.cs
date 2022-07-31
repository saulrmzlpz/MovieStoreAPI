using Dapper;
using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

namespace MovieStoreAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly string _sqlConnString;
        public UsersController(Models.DBHelper dbHelper)
        {
            _sqlConnString = dbHelper.ConnectionString;
        }

        [HttpPost("authenticate")]
        public IActionResult Authenticate([FromBody] Models.AuthUser authUser)
        {
            if (!ModelState.IsValid) return BadRequest();
            var user = Authenticate(authUser.AuthEmail, authUser.AuthPassword);
            if (user == null)
                return BadRequest(new { message = "Wrong username / password" });

            //var tokenHandler = new JwtSecurityTokenHandler();
            //var key = Encoding.ASCII.GetBytes("SECRET");
            //var tokenDescriptor = new SecurityTokenDescriptor
            //{
            //    Subject = new ClaimsIdentity(new Claim[]
            //    {
            //        new Claim(ClaimTypes.Name, user.userId.ToString())
            //    }),
            //    Expires = DateTime.UtcNow.AddDays(7),
            //    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            //};
            //var token = tokenHandler.CreateToken(tokenDescriptor);
            //var tokenString = tokenHandler.WriteToken(token);

            // return basic user info and authentication token
            return Ok(new
            {
                Id = user.UserId,
                UserEmail = user.UserEmail,
                FirstName = user.FirstName,
                LastName = user.LastName,
                MemberSince = user.MemberSince.ToString(("yyyy-MM-dd HH:mm:ss"))
            }); ;
        }

        [HttpPost("registration")]
        public IActionResult RegisterNewUser([FromBody] Models.User user)
        {
            if (!ModelState.IsValid) return BadRequest();
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            int affectedRows = connection.Execute("sp_add_user", new { firstName = user.FirstName, lastName = user.LastName, userEmail = user.UserEmail, userPassword = Helpers.MD5Crypto.Tools(user.UserPassword, Helpers.MD5Crypto.CryptOperation.Encrypt) }, commandType: System.Data.CommandType.StoredProcedure);

            if (affectedRows > 0) return Ok(affectedRows);
            return BadRequest(new { message = "A user with the specified email already exists" });
        }

        private Models.User Authenticate(string userEmail, string password)
        {
            if (string.IsNullOrEmpty(userEmail) || string.IsNullOrEmpty(password))
                return null;
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            Models.User user = connection.QueryFirstOrDefault<Models.User>("sp_get_user_info", new { userEmail = userEmail }, commandType: System.Data.CommandType.StoredProcedure);
            if (user == null)
                return null;
            if (!Helpers.MD5Crypto.VerifyPassword(password, user.UserPassword))
                return null;
            return user;
        }

    }
}
