using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MovieStoreAPI.Models
{
    public class AuthUser
    {
        [Required(ErrorMessage = "User Email must be submitted")]

        public string AuthEmail { get; set; }
        [Required(ErrorMessage = "User password must be submitted")]
        public string AuthPassword { get; set; }
    }
}
