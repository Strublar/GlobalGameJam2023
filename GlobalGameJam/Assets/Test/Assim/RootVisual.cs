using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class RootVisual : MonoBehaviour
{
    public List<Transform> bonesTransform = new List<Transform>();
    private float lastBoneRotation;


    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.E))
        {
            ResetRotation();
            SetRandomRotation();
        }
    }


    private void ResetRotation()
    {
        for(int i =0; i < bonesTransform.Count;i ++)
        {          
            bonesTransform[i].eulerAngles.Set(new Vector3(0,0,0));
        }
    }
        
    private void SetRandomRotation()
    {
        lastBoneRotation = 0;

        for(int i =0; i < bonesTransform.Count;i ++)
        {          
            lastBoneRotation += Random.Range(-20,20);
            Vector3 m_euler = bonesTransform[i].eulerAngles;
            bonesTransform[i].eulerAngles.Set(m_euler + new Vector3(0,0,lastBoneRotation));
        }
    }
}
