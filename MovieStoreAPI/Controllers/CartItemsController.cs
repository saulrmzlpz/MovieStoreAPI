using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MySqlConnector;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MovieStoreAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CartItemsController : ControllerBase
    {
        private readonly string _sqlConnString;
        public CartItemsController(Models.DBHelper dbHelper)
        {
            _sqlConnString = dbHelper.ConnectionString;
        }

        [HttpGet("{UserId}")]
        public IActionResult GetCartItems(int UserId)
        {
            if (UserId < 0) return BadRequest();
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            List<Models.CartItem> cartItems = new List<Models.CartItem>();
            cartItems = connection.Query<Models.CartItem>("sp_get_cart_items", new { userId = UserId }, commandType: System.Data.CommandType.StoredProcedure).ToList();
            return Ok(cartItems);

        }

        [HttpDelete("{CartItemId}")]
        public IActionResult DeleteCartItem(int CartItemId)
        {
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            int affectedRows = connection.Execute("sp_delete_cart_item", new { cartItemId = CartItemId }, commandType: System.Data.CommandType.StoredProcedure);
            return Ok(affectedRows);
        }

        [HttpPost]
        [Route("new")]
        public IActionResult InsertCartItem([FromBody]Models.CartItem CartItem)
        {
            if (!ModelState.IsValid) return BadRequest();
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            int affectedRows = connection.Execute("sp_add_cart_item", CartItem, commandType: System.Data.CommandType.StoredProcedure);
            return Ok(affectedRows);
        }
    }
}
