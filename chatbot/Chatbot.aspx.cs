using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using CsvHelper;

namespace ChatbotDemo
{
    public partial class chatbot : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string GetAnswer(string question)
        {
            // Read CSV file
            string csvPath = HttpContext.Current.Server.MapPath("~/App_Data/bank.csv");
            using (var reader = new StreamReader(csvPath))
            using (var csv = new CsvReader(reader, System.Globalization.CultureInfo.CurrentCulture))
            {
                var csvData = csv.GetRecords<dynamic>();
                var questions = new List<dynamic>();
                foreach (var row in csvData)
                {
                    // Calculate Jaccard Similarity between the question and the row's question value
                    var jaccardSimilarity = GetJaccardSimilarity(question, row.question);
                    questions.Add(new { question = row.question, answer = row.answer, similarity = jaccardSimilarity });
                }

                // Find question with highest similarity score greater than 0.7
                var highestSimilarityQuestion = questions.OrderByDescending(q => q.similarity).FirstOrDefault(q => q.similarity > 0.7);

                // If a high enough similarity score was found, return the answer for that question
                if (highestSimilarityQuestion != null)
                {
                    // Return response in JSON format
                    return highestSimilarityQuestion.answer;
                }
            }

            // If no answer was found, return an empty response in JSON format
            return "Sorry, i could not understand your question!";
        }



        private static double GetJaccardSimilarity(string str1, string str2)
        {
            var set1 = new HashSet<char>(str1.ToLower());
            var set2 = new HashSet<char>(str2.ToLower());
            var intersection = set1.Intersect(set2).Count();
            var union = set1.Union(set2).Count();
            return (double)intersection / union;
        }
    }
}