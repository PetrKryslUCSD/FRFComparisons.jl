module FRFComparisons

export cssf, csac, frfsm

"""
    cssf(f, d1, d2)

Cross Signature Scale Factor (CSF)

@inproceedings{Dascotte1999UpdatingFE,
  title={Updating finite element models using FRF correlation functions},
  author={Eddy Dascotte and J. Strobbe},
  year={1999},
  url={https://api.semanticscholar.org/CorpusID:128927492}
}

Both CSSF and CSAC were discussed in this paper. Together, these two FRF
correlation functions are referred to as the Cross Signature Correlation
(CSC) functions.
"""
function cssf(f, d1, d2)
    @assert length(f) == length(d1)
    @assert length(f) == length(d2)
    return 2 * dot(adjoint(d1), d2) / (dot(adjoint(d1), d1) + dot(adjoint(d2), d2))
end

"""
    csac(f, d1, d2)

Cross Signature Assurance Criterion (CSAC)

@inproceedings{Dascotte1999UpdatingFE,
  title={Updating finite element models using FRF correlation functions},
  author={Eddy Dascotte and J. Strobbe},
  year={1999},
  url={https://api.semanticscholar.org/CorpusID:128927492}
}

Both CSSF and CSAC were discussed in this paper. Together, these two FRF
correlation functions are referred to as the Cross Signature Correlation
(CSC) functions.
"""
function csac(f, d1, d2)
    @assert length(f) == length(d1)
    @assert length(f) == length(d2)
    return dot(adjoint(d1), d2)^2 / (dot(adjoint(d1), d1) * dot(adjoint(d2), d2))
end

function _erf(x, mu, sigma_squared)
    return 1 / sqrt(2*pi*sigma_squared) * exp(-(x - mu)^2 / sigma_squared / 2)
end


"""
    frfsm(f, d1, d2)

FRF (Frequent Response Function) Similarity Measure

@article{LEE201832,
title = {A metric on the similarity between two frequency response functions},
journal = {Journal of Sound and Vibration},
volume = {436},
pages = {32-45},
year = {2018},
issn = {0022-460X},
doi = {https://doi.org/10.1016/j.jsv.2018.08.051},
url = {https://www.sciencedirect.com/science/article/pii/S0022460X18305650},
author = {Dooho Lee and Tae-Soo Ahn and Hyeon-Seok Kim},
keywords = {Frequency response function, Model updating, Model validation, Similarity metric},
abstract = {This paper is focused on the development a new metric that can provide information on similarity between a frequency response function (FRF) from a finite element (FE) model and from an experiment to determine a target level of FE model accuracy in a deterministic sense. Typically, this metric could be used in setting a target level of model updating of an FE model that predicts structural-acoustic responses in high modal density mid-frequency regimes. The FRF similarity metric (FRFSM) is based on the likelihood between two FRFs with an assumed normal distribution of structural-acoustic responses. A normalization process over the frequency range of concern provides a metric value between 0 and 1. A numerical model that consists of two substructures and joint bushings objectively examined the characteristics of the proposed FRFSM with known parameter errors. The numerical study showed that the proposed FRFSM well represented the overall difference between two FRFs over the whole frequency band. Next, subjective evaluations that consist of evaluating the similarity for two pairs of FRFs by an expert group within an automotive company were conducted to assess the performance of the proposed metric. Subjective evaluations were conducted for various FRF sets in automotive noise and vibration responses. After compensating the subjective test results in calculating the correlation with the proposed metric, the performance of the metric was investigated. Additionally, the capability of the proposed metric when it represents the amount of updating in the frequency domain was illustrated by comparing the degree of correlation with the subjective evaluations. Comparisons with the results of the subjective evaluations showed that the FRFSM well represented the experts’ knowledge on the similarity of two FRFs, both in an absolute sense and in relative accuracies of the updated FE models.}
}

"""
function frfsm(f, d1, d2)
    @assert length(f) == length(d1)
    @assert length(f) == length(d2)
    sigma_squared = 6^2
    result = 0.0
    for j in eachindex(d1)
        ej = (10 * log10(abs(d1[j])^2)) - (10 * log10(abs(d2[j])^2))
        result += _erf(ej, 0, sigma_squared)
    end
    return result / length(d1) / _erf(0, 0, sigma_squared)
end


end # module FRFComparisons

#=
@article{doi:10.2514/1.24583,
author = {Lane, Steven A. and Lacy, Seth L. and Babuska, Vit and Carter, Delano},
title = {Correlation and Error Metrics for Plant Identification of On-Orbit Space Structures},
journal = {Journal of Spacecraft and Rockets},
volume = {44},
number = {3},
pages = {710-721},
year = {2007},
doi = {10.2514/1.24583},
URL = { https://doi.org/10.2514/1.24583},
}
=#
