using System.Collections.Generic;
using UnityEngine;

namespace src
{
    public class SpawnPoint : MonoBehaviour
    {
        private List<Transform> eligibleNeighbours; 
        void Start()
        {
            eligibleNeighbours = new List<Transform>();
            Collider[] hitColliders = Physics.OverlapSphere(transform.position, RootsManager.instance.GetMaxRootRange() - RootsManager.instance.GetMinRootRange());

            foreach (Collider collider in hitColliders)
            {
                if(collider.CompareTag("SpawnPoint"))
                {
                    //Debug.Log(collider.gameObject.name + " is within range.");
                    eligibleNeighbours.Add(collider.gameObject.transform);
                }
            }
        }

        public SpawnPoint getRandomNeighbour()
        {
            return eligibleNeighbours[Random.Range(0, eligibleNeighbours.Count)].GetComponent<SpawnPoint>();
        }
    }
}