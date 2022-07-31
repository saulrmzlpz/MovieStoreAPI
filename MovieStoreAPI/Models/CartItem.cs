using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace MovieStoreAPI.Models
{
    public class CartItem
    {
        public int CartItemId { get; set; }
        [Required(ErrorMessage = "User ID must be submitted")]
        public int UserId { get; set; }
        [Required(ErrorMessage = "Movie ID must be submitted")]
        public int MovieId { get; set; }
        [Required(ErrorMessage = "Movie Name must be submitted")]
        public string MovieName { get; set; }
        [Required(ErrorMessage = "ItemPrice must be submitted")]
        public double ItemPrice { get; set; }
        [Required(ErrorMessage = "ItemImage ID must be submitted")]
        public string ItemImg { get; set; }
        public DateTime ItemAddTimeStamp { get; set; }
    }
}
