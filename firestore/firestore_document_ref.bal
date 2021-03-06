documentation {
    Object to reference a document in a collection.

    F{{apiKey}} API key to authorization
    F{{client}} Http client endpoint for api
    F{{path}} Path to the document
}
public type FirestoreDocumentRef object {
    
    string apiKey;
    http:Client client;
    string path;

    new(apiKey, client, path) {}

    documentation {
        Returns snapshot of the document.

        R{{}} If success, returns Document with document snapshot, else returns `FirestoreError` object
    }
    public function get() returns Document|FirestoreError;

    documentation {
        Delete the document.

        R{{}} If success, returns null, else returns `FirestoreError` object
    }
    public function delete() returns ()|FirestoreError;

    documentation {
        Returns specified collection's reference of the document.

        P{{collection}} Collection in the document 
        R{{}} Returns FirestoreCollectionRef with specified collection's reference
    }
    public function collection(string collection) returns FirestoreCollectionRef;

};

function FirestoreDocumentRef::get() returns Document|FirestoreError {
    endpoint http:Client httpClient = self.client;
    var resp = httpClient->get(FIRESTORE_DOCUMENTS + self.path + "?key=" + self.apiKey);
    var doc = check parseResponseToDocument(resp);
    return doc; 
}

function FirestoreDocumentRef::delete() returns ()|FirestoreError {
    endpoint http:Client httpClient = self.client;
    var resp = httpClient->delete(FIRESTORE_DOCUMENTS + self.path + "?key=" + self.apiKey, ());
    return check parseResponseToNullOrError(resp);
}

function FirestoreDocumentRef::collection(string collection) returns FirestoreCollectionRef {
    FirestoreCollectionRef collectionRef = new (self.apiKey, self.client, self.path + "/" + collection);
    return collectionRef; 
}
