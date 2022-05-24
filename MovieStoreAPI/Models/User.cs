using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MovieStoreAPI.Models
{
    public class User
    {
        public int UserId { get; set; }
        [Required(ErrorMessage = "First Name must be submitted")]
        public string FirstName { get; set; }
        [Required(ErrorMessage = "Last Name must be submitted")]
        public string LastName { get; set; }
        [Required(ErrorMessage = "User Email must be submitted")]
        public string UserEmail { get; set; }
        [Required(ErrorMessage = "User password must be submitted")]
        public string UserPassword { get; set; }
        public DateTime MemberSince { get; set; } 
    }
}
