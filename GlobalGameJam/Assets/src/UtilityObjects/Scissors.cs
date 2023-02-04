using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scissors : MonoBehaviour
{
    [SerializeField] private Transform mouseTarget;

    // Update is called once per frame
    void Update()
    {
        transform.LookAt(mouseTarget);
    }
}
