using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace MovieStoreAPI.Models
{
    public class ShippingAddress
    {
        public int ShippingAddressId { get; set; }
        public int UserId{ get; set; }
        public string AddressLine1{ get; set; }
        public string AddressLine2{ get; set; }
        public string AddressZipCode{ get; set; }
        public string AddressName{ get; set; }
    }
}
