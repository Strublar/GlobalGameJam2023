using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestRaycast : MonoBehaviour
{
    public Transform ObjectToTestWith;


    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
            
        }


    }

    [ContextMenu("Test Position")]
    public void TestPosition() 
    {
        Debug.Log(ObjectToTestWith.InverseTransformPoint(transform.position));
    }
}
