// An Indextank Query. Inspired by indextank-java's com.flaptor.indextank.apiclient.IndextankClient.Query.


function Query (queryString) {
    this.queryString = queryString;
}

Query.prototype.withQueryString = function (qstr) {
    this.queryString = qstr;
    return this;
};

Query.prototype.withStart = function (start) {
    this.start = start;
    return this;
};


Query.prototype.withLength = function (rsLength) {
    this.rsLength = rsLength;
    return this;
};

Query.prototype.withScoringFunction = function ( scoringFunction ) {
    this.scoringFunction = scoringFunction;
    return this;
};

Query.prototype.withSnippetFields = function ( snippetFields ){
    if (typeof(snippetFields) == "string") {
        snippetFields = snippetFields.split(/ *: */);
    }

    if (this.snippetFields == null) {
        this.snippetFields = [];
    }

    this.snippetFields.push(snippetFields);
    return this;
};

Query.prototype.withFetchFields = function ( fetchFields ){
    if (typeof(fetchFields) == "string") {
        fetchFields = fetchFields.split(/ *: */);
    }

    if (this.fetchFields == null) {
        this.fetchFields = [];
    }

    this.fetchFields.push(fetchFields);
    return this;
};

Query.prototype.withDocumentVariableFilter = function (idx, floor, ceil) {
    if (this.documentVariableFilters == null) {
        this.documentVariableFilters = [];
    }

    this.documentVariableFilters.push(new Range(id, floor, ceil));
    return this;
};

Query.prototype.withFunctionFilter = function (idx, floor, ceil) {
    if (this.functionFilters == null) {
        this.functionFilters = [];
    }

    this.functionFilters.push(new Range(id, floor, ceil));
    return this;
};

Query.prototype.withCategoryFilters = function (categoryFilters) {
    if (this.categoryFilters == null) {
        this.categoryFilters = {};
    }

    for (c in categoryFilters) {
        this.categoryFilters[c] = categoryFilters[c];
    }

    return this;
};

Query.prototype.withoutCategories = function (categories) {
    if (this.categoryFilters == null) {
        this.categoryFilters = {};
    } else {
        for (idx in categories) {
            delete this.categoryFilters[categories[idx]];
        }
    }

    return this;
};

Query.prototype.withQueryVariables = function (queryVariables) {
    if (this.queryVariables == null) {
        this.queryVariables = {};
    }

    for (qv in queryVariables) {
        this.queryVariables[qv] = queryVariables[qv];
    }

    return this;
};


Query.prototype.withQueryReWriter = function (qrw) {
    this.queryReWriter = qrw;
    return this;
}

Query.prototype.withFetchVariables = function(fv) {
    this.fetchVariables = fv;
    return this;
}

Query.prototype.withFetchCategories = function(fc) {
    this.fetchCategories = fc;
    return this;
}


Query.prototype.clone = function() {
    q = new Query(this.queryString);

    // XXX should arrays and dicts be deep copied?
    if (this.start != null) q.start = this.start;
    if (this.rsLength != null) q.rsLength = this.rsLength;
    if (this.scoringFunction != null) q.scoringFunction = this.scoringFunction;
    if (this.snippetFields != null) q.snippetFields = this.snippetFields;
    if (this.fetchFields != null) q.fetchFields = this.fetchFields;
    if (this.categoryFilters != null) q.categoryFilters = this.categoryFilters;
    if (this.documentVariableFilters != null) q.documentVariableFilters = this.documentVariableFilters;
    if (this.functionFilters != null) q.functionFilters = this.functionFilters;
    if (this.queryVariables != null) q.queryVariables = this.queryVariables;
    if (this.queryReWriter != null) q.queryReWriter = this.queryReWriter;
    if (this.fetchVariables != null) q.fetchVariables = this.fetchVariables;
    if (this.fetchCategories != null) q.fetchCategories = this.fetchCategories;

    return q;
}

Query.prototype.asParameterMap = function() {
    var qMap = {};
    
    // start with the query.
    qMap["q"] = this.queryReWriter(this.queryString);

    if (this.start != null)         
        qMap['start'] = this.start;
    if (this.rsLength != null)
        qMap['len'] = this.rsLength;
    if (this.scoringFunction != null)
        qMap['function'] = this.scoringFunction;

    if (this.snippetFields != null)
        qMap['snippet'] = this.snippetFields.join(",");
    if (this.fetchFields != null)
        qMap['fetch'] = this.fetchFields.join(",");
    if (this.categoryFilters != null)
        qMap['category_filters'] = JSON.stringify(this.categoryFilters);
    if (this.fetchVariables != null)
        qMap['fetch_variables'] = this.fetchVariables;
    if (this.fetchCategories != null)
        qMap['fetch_categories'] = this.fetchCategories;

    if (this.documentVariableFilters != null) {
        for (dvf in this.documentVariableFilters) {
            rng = this.documentVariableFilters[dvf];
            key = rng.getFilterDocVar();
            val = rng.getValue();

            if (qMap[key]) { 
                qMap[key] += "," + val;
            } else {
                qMap[key] = val;
            }
        }
    }
 
    if (this.functionFilters != null) {
        for (ff in this.functionFilters) {
            rng = this.functionFilters[ff];
            key = rng.getFilterFunction();
            val = rng.getValue();

            if (qMap[key]) { 
                qMap[key] += "," + val;
            } else {
                qMap[key] = val;
            }
        }
    }

    if (this.queryVariables != null) {
        for (qv in this.queryVariables) {
            qMap[qv] = this.queryVariables[qv];
        }
    }

    return qMap;
};


function Range(id, floor, ceil) {
    this.id = id;
    this.floor = floor;
    this.ceil = ceil;
} 

Range.prototype.getFilterDocVar = function() {
    return "filter_docvar" + this.id;
};

Range.prototype.getFilterFunction = function() {
    return "filter_function" + this.id;
};

Range.prototype.getValue = function() {
    var value = [ (this.floor == null ? "*" : this.floor) , 
                  (this.ceil  == null ? "*" : this.ceil) ];

    return value.join(":");
};

