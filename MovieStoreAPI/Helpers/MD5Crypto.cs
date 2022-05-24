using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace MovieStoreAPI.Helpers
{
    class MD5Crypto
    {
        private static readonly string SecretKey = "854ed4d8-8de4-4640-a4c8-bff2009557b9";
        public static string Tools(string text, CryptOperation operation)
        {
            byte[] key;
            byte[] array = operation == CryptOperation.Encrypt ? Encoding.UTF8.GetBytes(text) : Convert.FromBase64String(text);
            using MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            key = md5.ComputeHash(Encoding.UTF8.GetBytes(SecretKey));
            md5.Clear();
            using TripleDESCryptoServiceProvider tripledes = new TripleDESCryptoServiceProvider();
            tripledes.Key = key;
            tripledes.Mode = CipherMode.ECB;
            tripledes.Padding = PaddingMode.PKCS7;
            using ICryptoTransform cryptoTransform = operation == CryptOperation.Encrypt ? tripledes.CreateEncryptor() : tripledes.CreateDecryptor();
            byte[] result = cryptoTransform.TransformFinalBlock(array, 0, array.Length);
            return operation == CryptOperation.Encrypt ? Convert.ToBase64String(result) : Encoding.UTF8.GetString(result);
        }

        public enum CryptOperation
        {
            Encrypt,
            Decrypt
        }

        public static bool VerifyPassword(string password, string Md5String)
        {
            if (password == null) throw new ArgumentNullException("password");
            if (string.IsNullOrWhiteSpace(password)) throw new ArgumentException("Value cannot be empty or whitespace only string.", "password");
            return password.Equals(Tools(Md5String, CryptOperation.Decrypt));
        }

    }
}
