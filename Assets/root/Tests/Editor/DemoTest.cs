using System.Collections;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;

namespace Package.Editor.Tests
{
    public partial class DemoTest
    {
        [UnitySetUp]
        public IEnumerator SetUp()
        {
            Debug.Log($"[{nameof(DemoTest)}] SetUp");
            yield return null;
        }
        [UnityTearDown]
        public IEnumerator TearDown()
        {
            Debug.Log($"[{nameof(DemoTest)}] TearDown");
            yield return null;
        }

        [UnityTest]
        public IEnumerator Always_Valid_Test()
        {
            Assert.IsTrue(true, "This test is a placeholder and should be replaced with actual test logic.");
            yield return null;
        }
    }
}