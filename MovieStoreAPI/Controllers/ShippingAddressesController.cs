using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MovieStoreAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ShippingAddressesController : ControllerBase
    {
        private readonly string _sqlConnString;
        public ShippingAddressesController(Models.DBHelper dbHelper)
        {
            _sqlConnString = dbHelper.ConnectionString;
        }


        [HttpGet("{UserId}")]
        public async Task<IActionResult> GetShippingAddresses(int userId)
        {
            if (userId < 0) return BadRequest();
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            IEnumerable<Models.ShippingAddress> shippingAddresses = new List<Models.ShippingAddress>();
            shippingAddresses = await connection.QueryAsync<Models.ShippingAddress>("sp_get_shipping_addr", new { userId = userId }, commandType: System.Data.CommandType.StoredProcedure);
            return Ok(shippingAddresses);
        }

        [HttpDelete("{AddrId}")]
        public IActionResult DeleteShippingAddress(int addrId)
        {
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            int affectedRows = connection.Execute("sp_delete_shipping_addr", new { addrId = addrId }, commandType: System.Data.CommandType.StoredProcedure);
            return Ok(affectedRows);
        }

        [HttpPut("{AddrId}")]
        public IActionResult UpdateShippingAddress([FromBody] Models.ShippingAddress shippingAddress)
        {
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            int affectedRows = connection.Execute("sp_edit_shipping_addr", shippingAddress, commandType: System.Data.CommandType.StoredProcedure);
            return Ok(affectedRows);
        }

        [HttpPost]
        [Route("new")]
        public IActionResult InsertShippingAddress([FromBody] Models.ShippingAddress shippingAddress)
        {
            if (!ModelState.IsValid) return BadRequest();
            using MySqlConnection connection = new MySqlConnection(_sqlConnString);
            connection.Open();
            int affectedRows = connection.Execute("sp_add_shipping_addr", shippingAddress, commandType: System.Data.CommandType.StoredProcedure);
            return Ok(affectedRows);
        }
    }
}
