using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using src;


public class RootVisual : MonoBehaviour
{
    public List<Transform> bonesTransform = new List<Transform>();
    private float lastBoneRotation;

    public GameObject m_rootBaseObject;
    private Renderer m_rootBaseMesh;

    private GameObject m_rootCutObject;
    private Renderer m_rootCutMesh;

    public float timeToGrow = 2;
    public float m_rootProgression;
    private Vector4 m_MaskParams;
    private bool isGrowing;
    private bool isShrinking;

    private float fakePhysicsProgression;

    public float wiggleAmount = 10;

    public bool solid = false;
    private Vector3 endPoint;
    public int Longevity = 3;

    public GameObject FleurPrefab;
    private GameObject linkedFlower;

    private void Awake()
    {
        m_rootBaseMesh = m_rootBaseObject.GetComponentInChildren<SkinnedMeshRenderer>();
        m_MaskParams = m_rootBaseMesh.material.GetVector("_RootMask");
        m_rootBaseMesh.material.SetVector("_RootMask", new Vector4(m_MaskParams.x, 0, m_MaskParams.z, m_MaskParams.w));
        timeToGrow += Random.Range(-.3f, .3f);
        isGrowing = true;
    }


    void Start()
    {
        SetRandomRotation();
        GenerateCuttedRoot();
        SpawnFlower();
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.R))
        {
            SetRandomRotation();
        }

        if (Input.GetKeyDown(KeyCode.C))
        {
            CutRoot(Random.Range(0.1f,0.9f));
        }

        if (isGrowing) 
        {
            Grow();
        }
        else 
        {
            if (isShrinking && !solid) 
            {
                Shrink();
            }
        }
    }


    [ContextMenu("Reset Rotation")]
    private void ResetRotation()
    {
        for(int i =0; i < bonesTransform.Count;i ++)
        {          
            bonesTransform[i].localEulerAngles = new Vector3(0,0,0);
        }
    }

    [ContextMenu("Set Random Rotation")]

    private void SetRandomRotation()
    {
        ResetRotation();
        lastBoneRotation = 0;

        for(int i =0; i < bonesTransform.Count;i ++)
        {          
            lastBoneRotation += Random.Range(-wiggleAmount, wiggleAmount);
            Vector3 m_euler = bonesTransform[i].localEulerAngles;
            bonesTransform[i].localEulerAngles = m_euler + new Vector3(0, 0, lastBoneRotation);
            if(i == bonesTransform.Count - 1) 
            {
                endPoint = bonesTransform[i].transform.position;
            }
        }
    }

    private void GenerateCuttedRoot() 
    {
        m_rootCutObject = Instantiate(m_rootBaseObject, this.transform);
        m_rootCutObject.name = "_Cutted";
        m_rootCutMesh = m_rootCutObject.GetComponentInChildren<SkinnedMeshRenderer>();
        m_rootCutObject.SetActive(false);
    }

    private void SpawnFlower() 
    {
        linkedFlower = Instantiate(FleurPrefab, endPoint, Quaternion.identity);
    }
    private void KillFlower() 
    {
        Destroy(linkedFlower);
    }

    public void CutRoot(float position) 
    {
        if (solid || isShrinking) 
        {
            Debug.Log("Tried to Cut but root is solid");
            return;
        }
        isGrowing = false;
        float currentProgression = m_rootBaseMesh.material.GetVector("_RootMask").y;

        m_rootCutObject.SetActive(true);
        m_rootCutMesh.material.SetVector("_RootMask", new Vector4(position, currentProgression, m_MaskParams.z, m_MaskParams.w));
        Transform[] m_cuttedRootBones = m_rootCutObject.transform.Find("Armature").transform.GetComponentsInChildren<Transform>();
        for (int i = 0; i < m_cuttedRootBones.Length; i++)
        {
            m_cuttedRootBones[i].gameObject.AddComponent<Rigidbody>();
            m_cuttedRootBones[i].gameObject.AddComponent<SphereCollider>().radius = 0.2f;
            if(i > 0) 
            {
                HingeJoint m_joint = m_cuttedRootBones[i].gameObject.AddComponent<HingeJoint>();
                m_joint.connectedBody = m_cuttedRootBones[i - 1].GetComponent<Rigidbody>();
                m_joint.axis = new Vector3(1, 0, 0);
            }


        }

        m_rootBaseMesh.material.SetVector("_RootMask", new Vector4(m_MaskParams.x, position, m_MaskParams.z, m_MaskParams.w));
        m_rootBaseMesh.material.SetColor("_Color", Color.grey);
        isShrinking = true;
        m_rootProgression = position;
        KillFlower();
    }
    

    private void Grow() 
    {
        if(m_rootProgression < 1) 
        {
            m_rootProgression += Time.deltaTime / timeToGrow;
            m_rootBaseMesh.material.SetVector("_RootMask", new Vector4(m_MaskParams.x, m_rootProgression, m_MaskParams.z, m_MaskParams.w));
        }
        else 
        {
            if (!solid) 
            {
                Solidify();

            }
            if (m_rootProgression < 2)
            {
                m_rootProgression += Time.deltaTime / timeToGrow;
                m_rootBaseMesh.material.SetVector("_RootMask", new Vector4(m_MaskParams.x, m_rootProgression, m_MaskParams.z, m_MaskParams.w));
            }
        }
    }

    private void Shrink() 
    {
        if (m_rootProgression > 0)
        {
            m_rootProgression -= Time.deltaTime * 0.2f;
            m_rootBaseMesh.material.SetVector("_RootMask", new Vector4(m_MaskParams.x, m_rootProgression, m_MaskParams.z, m_MaskParams.w));
        }
    }

    private void Solidify() 
    {
        solid = true;
        for (int i = 0; i < bonesTransform.Count; i++)
        {
            bonesTransform[i].tag = "Wall";
        }
        m_rootBaseMesh.material.SetColor("_Color", Color.black);
        Longevity--;
        if (Longevity > 0) 
        {      
            RootsManager.instance.SpawnRootFromPosition(endPoint, Longevity, transform.eulerAngles.y);
            //lower child longevity
        }

    }
}
