using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetArrow : MonoBehaviour
{
    [SerializeField] private Transform mouseTarget;
    

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(mouseTarget);
    }
}
