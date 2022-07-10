
import React from 'react';

/* This code isn't used but used to be for the front page to show the best deals.  Can be repurposed later. */
function Carousel({ deals, destinations }) {
    return (
        <div id="carouselExampleDark" className="carousel carousel-dark slide" data-bs-ride="carousel">
            <div className="carousel-indicators">
                {deals.map((item, index) =>
                    <button type="button" data-bs-target={`#carouselExampleDark-${index}`}
                        data-bs-slide-to={index} className="active"
                        aria-current="true" aria-label={`"Slide ${index}`}>
                    </button>
                )}
            </div>
            <div className="carousel-inner">
                {deals.map((item, index) =>
                    <div key={index} className={index === 0 ? "carousel-item active" : "carousel-item"}>

                        <div className="carousel-caption d-block">
                            <ShowDeal deal={item} destinations={destinations} />
                        </div>
                    </div>
                )}
            </div>
            <button className="carousel-control-prev" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="prev">
                <span className="carousel-control-prev-icon" aria-hidden="true"></span>
                <span className="visually-hidden">Previous</span>
            </button>
            <button className="carousel-control-next" type="button" data-bs-target="#carouselExampleDark" data-bs-slide="next">
                <span className="carousel-control-next-icon" aria-hidden="true"></span>
                <span className="visually-hidden">Next</span>
            </button>
        </div>
    )
}

export default Carousel;