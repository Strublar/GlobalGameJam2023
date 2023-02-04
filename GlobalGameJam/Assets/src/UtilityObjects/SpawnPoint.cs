using System.Collections.Generic;
using UnityEngine;

namespace src
{
    public class SpawnPoint : MonoBehaviour
    {
        private List<Transform> _eligibleNeighbours; 
        void Start()
        {
            _eligibleNeighbours = new List<Transform>();
            Collider[] hitColliders = Physics.OverlapSphere(transform.position, RootsManager._instance.GetMaxRootRange() - RootsManager._instance.GetMinRootRange());

            foreach (Collider collider in hitColliders)
            {
                if(collider.CompareTag("SpawnPoint"))
                {
                    Debug.Log(collider.gameObject.name + " is within range.");
                    _eligibleNeighbours.Add(collider.gameObject.transform);
                }
            }
        }

        public SpawnPoint getRandomNeighbour()
        {
            return _eligibleNeighbours[Random.Range(0, _eligibleNeighbours.Count)].GetComponent<SpawnPoint>();
        }
    }
}